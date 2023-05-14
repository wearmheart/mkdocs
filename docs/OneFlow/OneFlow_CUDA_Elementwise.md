- [ ] OneFlow CUDA Elementwise

## 引言
逐元素操作（也叫 Elementwise 操作）是指对 Tensor 中的每个元素应用一个函数变换，得到最终输出结果。

在深度学习里，有很多算子属于 Elementwise 算子范畴，比如常用的激活函数（如ReLU、GELU ），ScalarMultiply（对 Tensor 每个元素都乘上一个标量）等操作。
## 使用 
为此 OneFlow 针对这种 Elementwise 操作抽象出一套 CUDA 模板，**开发者只需把计算逻辑封装到一个结构体内，即可获得一个 CUDA Elementwise 算子**，以 ReLU 为例：
![image](https://user-images.githubusercontent.com/118866310/224601887-e3e46278-caeb-49f6-a885-038fa06e1683.png)
[ReLU激活函数详细介绍](https://www.zhihu.com/people/xiao-mei-16-47)

```c++
// 这是一个用于计算ReLU（rectified linear unit）函数的functor。

// 它是一个模板结构体，接受一个类型参数T，表示输入和输出的数据类型。

// Write ReLU Functor. 
template<typename T>
struct ReluFunctor {
  OF_DEVICE_FUNC T operator()(T x) const {
    const T zero_val = static_cast<T>(0); 
    return (x > zero_val) ? x : zero_val; 
  }
};
// 函数体内的代码实现了ReLU函数的计算。首先，声明一个常量zero_val，表示零值，其类型为T。

// 由于T可能是不同的数据类型，所以使用static_cast进行类型转换。

// 然后，根据ReLU函数的定义，如果输入x大于零，则输出为x，否则输出为0。

// 这个判断通过三目运算符实现，如果x大于zero_val，则返回x，否则返回zero_val（即0）。

// 需要注意的是，OF_DEVICE_FUNC是一个OpenFusion的宏定义，用于指定这个functor可以在设备上运行（即在CUDA设备上运行）。
```

```c++
// Use CUDA Elementwise Template. 
OF_CUDA_CHECK((cuda::elementwise::Unary(ReluFunctor<T>(), elem_cnt, dx->mut_dptr<T>(),
                                        x->dptr<T>(), ctx->stream()->As<ep::CudaStream>()->cuda_stream())));
```

这段代码使用CUDA Elementwise模板，它可以在GPU上执行单元操作，以实现加速。
- ReluFunctor<T>() 是一个自定义的函数对象，用于对输入数据执行 relu 操作，它将被应用于 x->dptr<T>() 中的每个元素。
- elem_cnt 是元素的数量。
- dx->mut_dptr<T>() 是一个可变指针，指向要修改的输出数据（即 relu 操作后的结果）。
- x->dptr<T>() 是一个常量指针，指向输入数据。
- ctx->stream()->As<ep::CudaStream>()->cuda_stream() 是一个 CUDA 流，用于在 GPU 上执行操作。
- OF_CUDA_CHECK 宏用于检查 CUDA 操作是否成功执行，如果出现错误，则会在控制台输出错误信息。

## 原理介绍
[高效、易用、可拓展我全都要：OneFlow CUDA Elementwise 模板库的设计优化思路](https://zhuanlan.zhihu.com/p/447577193)