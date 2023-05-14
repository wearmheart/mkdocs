# 如何在 OneFlow 中新增算子

本文将以开发一个 leaky_relu（准确说是 leaky_relu_yzh op，因为 master 分支的 leaky_relu 组合了其它知识点，不适合作为教程展示）为例介绍如何在 OneFlow 中新增算子。

本文对应的 PR 在 https://github.com/Oneflow-Inc/oneflow/pull/8350

## 背景

### op 与 kernel

在上文提到 “定义 op” 与 “实现 kernel 计算逻辑” 两个步骤，这里的 op 与 kernel 是两个有关联的概念。

op 是逻辑上的算子，包含 OneFlow Compiling Runtime 在构建计算图时所需要的必要信息，如输入、输出形状，哪些张量需要自动求导等信息。
有了 op 中的信息，OneFlow Compiling Runtime 就可以构建计算图并依据计算图做资源申请、构建等操作（如根据张量的输入输出大小申请内存），
但是 op 中不包含具体的处理数据的逻辑。

在真正需要处理数据时，OneFlow Executing Runtime 会启动 kernel 完成计算，所以 kernel 中包含了具体处理数据的逻辑。
对于一个逻辑上的 op，OneFlow Executing Runtime 会根据数据类型、硬件设备（比如是 CPU 还是 CUDA）的具体情况，选择启动不同的 kernel。

### OneFlow 中的系统 op 与 user op

在 OneFlow 系统中存在两类算子（op）：系统 op 和 user op。

系统 op 定义在：[oneflow/core/operator/](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/core/operator) 目录，
对应的 kernel 实现在：[oneflow/core/kernel](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/core/kernel) 目录。
系统 op 是对构图、流水等系统性能较为关键的一些 op。


除极少数 op 属于系统 op 外，大多数 op 都是 user op，这些 user op 和用户模型业务逻辑相关。
OneFlow user op 的定义及 kernel 实现分别在 [oneflow/user/ops](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/user/ops) 和 [oneflow/user/kernels](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/user/kernels) 目录下。


目前 OneFlow 已实现了丰富的算子库，但是当已有的算子库无法满足搭建模型的需求时，就需要新增算子。
本文介绍的新增算子指的是 **新增 user op**。

### ODS 与 TableGen

[TableGen](https://llvm.org/docs/TableGen/index.html) 是一个代码生成工具，简单而言，它读取并解析一个 `.td` 格式（语法接近 C++ 模板）的文件，然后交给 [TableGen 后端](https://llvm.org/docs/TableGen/BackEnds.html) 生成另外格式的语言。

MLIR 基于 TableGen 制定了一套算子定义规范 [ODS](https://mlir.llvm.org/docs/OpDefinitions/) 以及对应的后端 [OpDefinitionsGen](https://github.com/llvm/llvm-project/blob/main/mlir/tools/mlir-tblgen/OpDefinitionsGen.cpp)

OneFlow 在 ODS 的基础上，实现了 [TableGen OneFlow 后端](https://github.com/Oneflow-Inc/oneflow/tree/master/tools/oneflow-tblgen)，并使用它来定义 OneFlow user op。

因此，OneFlow 的 user op 定义写在 [OneFlowUserOps.td](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/ir/include/OneFlow/OneFlowUserOps.td) 文件中。

## 开发 op

在 OneFlow 中开发一个新的 user op，大致流程如下图。

![image](https://user-images.githubusercontent.com/118866310/226204352-90bf5617-e56d-4d9d-b342-cec25e37841c.png)

主要分为以下4步：
1. 定义 op
2. 实现 kernel 计算逻辑
3. 导出 functional 接口
4. 实现用于求导的反向逻辑 (上图中 4. 5.)

### 定义 op

定义 op 指的是，对 op 的名称，op 的输入、输出数据类型和 op 的属性进行声明。
OneFlow 遵循 MLIR 的 [ODS（Operation Definition Specification）](https://mlir.llvm.org/docs/OpDefinitions/) 实现了自己的 MLIR OneFlow Dialect。
在算子定义方面，这样做的好处是，各种推导函数和序列化/反序列化的接口都可以委托给 ODS，降低了人工手写出错的概率，后续优化、格式转化等流程可以更灵活。

定义一个 OneFlow user op，主要包括 5 个部分，分别是：

- op class
- 输入 input
- 输出 output
- 属性 attrs
- 导出并实现推导接口

#### op class

可以在 [oneflow/ir/include/OneFlow/OneFlowUserOps.td](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/ir/include/OneFlow/OneFlowUserOps.td#L8418-L8451) 查看 op 定义的源码。

以 `def` 关键字开头定义一个 op，该 op 继承 `OneFlow_BaseOp`，同时指定 `OneFlow_BaseOp` 的模版参数。
模版参数依次为 op type name、[Trait](https://mlir.llvm.org/docs/Traits/) 列表。

```c++
def OneFlow_LeakyReluYZHOp : OneFlow_BaseOp<"leaky_relu_yzh", [NoSideEffect, DeclareOpInterfaceMethods<UserOpCompatibleInterface>]> {
//...
}
```

其中 `"leaky_relu_yzh"` 是指定的 op type name。每个 op 都需要指定一个全局唯一的 op type name 作为全局标识符。

第二个模板参数是一个 list（`[...]`），其中的每一项都是一个 Trait，OneFlow 中常用的有：

- `NoSideEffect` 表示该算子无副作用（即不会改变内存、网络、管道、磁盘等的系统状态），这个特性可以指导某些优化操作
- `NoGrad` 表示该算子在数学上没有梯度（不可导）
- `CpuOnly` 表示该算子只支持在 CPU 设备上执行
- `SupportNonContiguous` 表示该算子是否支持 NonContiguous 张量（关于 Contiguous Tensor 的概念，可以参考 [PyTorch Internals 中的相关内容](http://blog.ezyang.com/2019/05/pytorch-internals/) ）

#### 输入 input 与输出 output

通过重写 `input` 域来定义 op 的输入，比如

```c++
// 一个输入 x
let input = (ins
  OneFlow_Tensor:$x
);
```

定义了一个输入张量 `x`。输入的格式为 `输入类型:$name`。

输入类型目前包括：

- `OneFlow_Tensor`
- `Variadic<OneFlow_Tensor>`：指可变 tensor，比如 concat op，支持 concat 可变个数的 tensor。
- `Optional<OneFlow_Tensor>`：表示这个 tensor 是可选的，既可以有也可以没有，比如 conv op 中的 add_output。

一个 op 也可以定义多个输入，比如：

```c++
  // 两个输入：a, b
  let input = (ins
    OneFlow_Tensor:$a,
    OneFlow_Tensor:$b
  );
```

通过重写 `output` 域来定义 op 的输出，比如

```c++
let output = (outs
  OneFlow_Tensor:$out0,
  OneFlow_Tensor:$out1
);
```

定义了 2 个输出张量。

#### 属性 attrs

通过重写 `attrs` 域定义 op 的属性，比如定义 [dropout](https://oneflow.readthedocs.io/en/master/functional.html#oneflow.nn.functional.dropout) 中的 `rate` 属性，

```c++
  let attrs = (ins
    DefaultValuedAttr<F32Attr, "0.">:$rate
  );
```

它表示名为 `$rate` 的类型是 `F32Attr`，默认值是 `0.`。也可以不指定默认值：

```c++
  let attrs = (ins
    F32Attr:$rate
  );
```

I32Attr、F32Attr、BoolAttr、StrAttr、I32ArrayAttr 等常见基础数据类型定义在 [OpBase.td](https://github.com/llvm/llvm-project/blob/main/mlir/include/mlir/IR/OpBase.td#L1077-L1086) 中。

OneFlow 自定义数据类型，如 ShapeAttr、DTArrayAttr 等定义在 [OneFlowBase.td](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/ir/include/OneFlow/OneFlowBase.td#L27-L35) 中。

#### 导出并实现推导接口

还有一些其它域，用于指定是否生成对应的接口。这些接口往往是构建计算图过程中的推导接口。

比如 shape 推导（根据输入的 shape 推导输出的推导）、data type 推导、SBP 推导等。

OneFlow-TableGen 仅负责生成这些函数的接口，开发者需要在其自动生成的 cpp 文件中实现这些接口。
默认情况不会生成下列任何接口，开发者需要显式指定需要生成哪些接口。

```c++
  let has_check_fn = 1;                         // 生成属性检查接口
  let has_logical_tensor_desc_infer_fn = 1;     // 生成 logical shape 推导接口
  let has_physical_tensor_desc_infer_fn = 1;    // 生成 physical shape 推导接口
  let has_get_sbp_fn = 1;                       // 生成 get sbp 接口
  let has_sbp_signature_infer_fn = 1;           // 生成 sbp signature 推导接口，未来会移除，推荐使用 has_nd_sbp_infer_fn
  let has_data_type_infer_fn = 1;               // 生成 data type 推导接口
  let has_device_and_stream_infer_fn = 1;       // 生成 device 推导接口
  let has_input_arg_modify_fn = 1;              // 生成输入 modify 接口，比如设置 is_mutable、requires_grad（用于Lazy）等
  let has_output_arg_modify_fn = 1;             // 生成输出 modify 接口，比如设置 is_mutable、requires_grad（用于Lazy）等
  let has_output_blob_time_shape_infer_fn = 1;  // 生成输出 time shape 推导接口
  let has_nd_sbp_infer_fn = 1;                  // 生成 nd sbp 推导接口
```

一般常用的是下面几个，

```c++
    let has_logical_tensor_desc_infer_fn = 1;     // 生成 logical shape 推导接口
    let has_physical_tensor_desc_infer_fn = 1;    // 生成 physical shape 推导接口
    let has_data_type_infer_fn = 1;               // 生成 data type 推导接口
    let has_nd_sbp_infer_fn = 1;                  // 生成 nd sbp 推导接口
```

了解完上面这些概念和用法后，可以开始修改 [oneflow/ir/include/OneFlow/OneFlowUserOps.td](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/ir/include/OneFlow/OneFlowUserOps.td)文件。

leaky_relu_yzh op 完整的定义见 [这里](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/ir/include/OneFlow/OneFlowUserOps.td#L8418-L8433)：

在 `OneFlowUserOps.td` 中新增Op定义之后，重新 make 后会自动在 **build** 目录下的 `oneflow/core/framework/` 目录下生成文件以下几个文件：

- `op_generated.h`：由解析 `.td` 文件生成的 op C++ 类
- `op_generated.cpp`：由解析 `.td` 文件生成的 op 注册代码（包含调用 `REGISTER_USER_OP` 宏的代码）

之后需要做的就是在 [oneflow/user/ops](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/user/ops) 目录下新加一个 cpp 文件，用于实现 op 的接口。

比如 leaky_relu_yzh 对应的文件在 [oneflow/user/ops/leaky_relu_yzh_op.cpp](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/user/ops/leaky_relu_yzh_op.cpp#L21-L79)

实现了推导逻辑张量、推导物理张量、推导 SBP 信息以及推导输出数据类型各接口。


### 实现 Kernel 逻辑

op 的计算支持多种设备（如 CPU、GPU、DCU 等），所以要分别实现计算逻辑。

相关代码：

- [Leaky ReLU CPU Kernel](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/user/kernels/leaky_relu_yzh_kernel.cpp)
- [Leaky ReLU GPU Kernel](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/user/kernels/leaky_relu_yzh_kernel.cu)

#### CPU 计算逻辑

```cpp
template<typename T>
class CpuLeakyReluYZHKernel final : public user_op::OpKernel {
 public:
  CpuLeakyReluYZHKernel() = default;
  ~CpuLeakyReluYZHKernel() = default;

 private:
  void Compute(user_op::KernelComputeContext* ctx) const override {
    const user_op::Tensor* x = ctx->Tensor4ArgNameAndIndex("x", 0);
    user_op::Tensor* y = ctx->Tensor4ArgNameAndIndex("y", 0);
    const int32_t elem_cnt = x->shape().elem_cnt();
    const T* x_ptr = x->dptr<T>();
    T* y_ptr = y->mut_dptr<T>();
    const auto alpha = ctx->Attr<float>("alpha");
    FOR_RANGE(int32_t, i, 0, elem_cnt) { y_ptr[i] = x_ptr[i] > 0 ? x_ptr[i] : alpha * x_ptr[i]; }
  }
  bool AlwaysComputeWhenAllOutputsEmpty() const override { return false; }
};
```

在 OneFlow 中实现 kernel， 必须定义一个继承自 `oneflow::user_op::OpKernel` 的类，并重写其中的虚函数。
在以上代码中，重写了 `Compute` 与 `AlwaysComputeWhenAllOutputsEmpty` 两个虚函数，它们的意义分别是：

- `Compute` 必须重写，在其中实现具体的运算逻辑
- `AlwaysComputeWhenAllOutputsEmpty` 必须重写，对于绝大多数 op 而言，直接返回 false 即可。对于极少数内部需要维护状态，即使输出为空也需要调用 kernel 进行计算的 op 而言，应该返回 true


`Compute` 方法中通过调用 `user_op::KernelComputeContext* ctx` 中的接口，可以获取输入张量、输出张量、attr 具体的数据，再按照算子的算法逻辑对它们进行处理。
以下是对 `CpuLeakyReluKernel::Compute` 处理逻辑的解读： 

- 首先取得 `"x"`，`"y"` 两个 Tensor。传入`Tensor4ArgNameAndIndex`的字符串要和之前在`OneFlowUserOps.td`设置的名称一致
- 获取 `x` 的元素个数，以便后续用于 `for` 循环进行计算
- 获取属性 `alpha`
- 进入次数为 `elem_cnt` 的 `for` 循环，将结果写入

#### 注册 Kernel

实现 kernel 类后，需要调用 `REGISTER_USER_KERNEL` 注册。

```cpp
#define REGISTER_CPU_LEAKY_RELU_YZH_KERNEL(dtype)                     \
  REGISTER_USER_KERNEL("leaky_relu_yzh")                              \
      .SetCreateFn<CpuLeakyReluYZHKernel<dtype>>()                    \
      .SetIsMatchedHob((user_op::HobDeviceType() == DeviceType::kCPU) \
                       && (user_op::HobDataType("y", 0) == GetDataType<dtype>::value));
```

这里会调用`REGISTER_USER_KERNEL`宏，包括以下信息：

1. op type name：为哪个 op 注册 kernel
2. `SetCreateFn<T>()`：该模板方法的模板参数 `T`，就是我们实现的 kernel 类，OneFlow Runtime 将使用它创建 kernel 对象。
3. `SetIsMatchedHob`：因为一个 op 可能有多个 kernel，要想根据物理设备及数据格式的不同而选择不同的 kernel 进行计算，就需要调用 SetIsMatchedHob 进行设置。该方法接受一个表达式，表达式为 true 时，OneFlow 将调用该 kernel 完成计算。以上代码的匹配逻辑是：当硬件设备为 `cpu`，且 `y` 的数据类型和 `dtype` 一致时，选择调用注册的 kernel 类（`CpuLeakyReluYZHKernel<dtype>`）。

#### GPU 计算逻辑

CUDA 编程基础知识入门可以参考：

- [视频：CUDA 的由来](https://www.bilibili.com/video/BV1Mb4y1p7BG)
- [视频：CUDA 的入门小程序](https://www.bilibili.com/video/BV1bF411s76k)
- [视频：线程层级](https://www.bilibili.com/video/BV1MZ4y127Sq)

不过以上的视频都无法替代自己认真学习官方资料：[CUDA C Programming Guide](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html)

了解了 CUDA 的基础知识，就不难理解 leaky_relu CUDA 版本的实现。

首先定义了 leaky_relu 前向运算的 CUDA 核函数

```cpp
template<typename T>
__global__ void LeakyReluForwardGpu(const int n, const float alpha, const T* x, T* y) {
  CUDA_1D_KERNEL_LOOP(i, n) { y[i] = x[i] > 0 ? x[i] : x[i] * alpha; }
}
```

其中调用了宏 [CUDA_1D_KERNEL_LOOP](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/core/device/cuda_util.h#L91-L94) 进行运算

在 Compute 函数中，调用了 `RUN_CUDA_KERNEL` (也是定义在 `cuda_util.h` 这个文件中)这个宏启动核函数。

对应的 GPU kernel 类的实现见：

https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/user/kernels/leaky_relu_yzh_kernel.cu#L32-L49

其中用到了启动 kernel 的宏 `RUN_CUDA_KERNEL`，它的定义是:

```cpp
#define RUN_CUDA_KERNEL(func, device_ctx_ptr, thread_num, ...)           \
  func<<<SMBlocksNum4ThreadsNum(thread_num), kCudaThreadsNumPerBlock, 0, \
         (device_ctx_ptr)->cuda_stream()>>>(__VA_ARGS__)
```

1. 第一个参数是核函数名字
2. 第二个参数是 device context，后续获取对应的 cuda_stream
3. 第三个参数是要启动的线程数量，会根据线程数量来计算所需的 Block 数目。

因为 leaky relu 是 elementwise 运算，各个元素互不影响，所以我们启动了 elem_cnt 个线程。

后续的注册与 CPU 版本类似，这里不再赘述。直接参考以下代码即可：

https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/user/kernels/leaky_relu_yzh_kernel.cu#L51-L62

> 可以看到不同设备类的 Compute 中大部分代码是重复的。一种更优的代码组织方式是用一个 `.cpp` 文件完成 kernel 和注册的逻辑，`.cu` 文件编写 GPU Kernel 函数和 GPU 模板特化的代码，`.h` 文件用于定义和编写注册宏。可参考 [dim_gather_kernel_\*](https://github.com/Oneflow-Inc/oneflow/tree/master/oneflow/user/kernels) 中的代码。

> OneFlow 为了适配多种设备，还提供了 Primitive 组件，可以参考：[Primitive PR](https://github.com/Oneflow-Inc/oneflow/pull/6234)

### 导出 functional 接口

关于 functional 接口层的详细介绍在这里： https://github.com/Oneflow-Inc/oneflow/wiki/Functional-Interface

概括而言，functional 层起到了“上接 Python，下联 C++”的作用：

```text

   ┌─────────────┐
   │   Module    │
   │  (Python)   │
   ├─────────────┤
   │             │
   │ Functional  │
   ├─────────────┤
   │             │
   │ Op/Kernels  │
   │   (C++)     │
   └─────────────┘
```

因此，在上文定义 op 和注册 kernel 后，需要为算子导出 functional 接口，才能使用户通过 Python 代码调用该算子。

导出 functional 接口分为以下几个步骤：

1. 实现对应的 functor 并注册
2. 在 [oneflow/core/functional/functional_api.yaml](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/core/functional/functional_api.yaml) 中添加接口描述 

#### 实现对应的 functor 并注册

对于 leaky_relu_yzh op，在 [activation_functor.cpp](https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/core/functional/impl/activation_functor.cpp#L391-L421) 中，对其进行定义：

```cpp
class LeakyReluYZHFunctor {
 public:
  LeakyReluYZHFunctor() {
    op_ = CHECK_JUST(one::OpBuilder("leaky_relu_yzh").Input("x").Output("y").Build());
  }
  Maybe<Tensor> operator()(const std::shared_ptr<one::Tensor>& x, const float& alpha) const {
    MutableAttrMap attrs;
    JUST(attrs.SetAttr<float>("alpha", alpha));
    return OpInterpUtil::Dispatch<one::Tensor>(*op_, {x}, attrs);
  }

 private:
  std::shared_ptr<OpExpr> op_;
};
```

- 在构造函数里，构造了 `leaky_relu` 这个op
- 实现 `operator()` 重载运算符，通过 `Dispatch` 调用构造好的 op，并分别传入输入，属性

类似的我们也给 LeakyReluGrad 导出 functional 接口，以便后续编写求导逻辑使用

最后我们需要注册到 Functional Library：

https://github.com/Oneflow-Inc/oneflow/blob/7ab4b0f08c86a6f8af08b44daa510725942288fb/oneflow/core/functional/impl/activation_functor.cpp#L610-L611

```cpp
m.add_functor<impl::LeakyReluYZHFunctor>("LeakyReluYZH"); // 注意最后字符串中的名字在后续的 functional_api.yaml 中会用到
```

通过 `m.add_functor` 注册后的 functor，可以在 C++ 层使用，如通过 `functional::LeakyRelu` 就可以调用 `LeakyReluFunctor`。

#### 在 functional_api.yaml 中添加接口描述

functional 通过解析 yaml 配置文件，在 build 过程中自动帮我们生成接口。

在[functional_api.yaml](https://github.com/Oneflow-Inc/oneflow/blob/master/oneflow/core/functional/functional_api.yaml) 文件中，编写相关配置。

https://github.com/Oneflow-Inc/oneflow/pull/8350/files#diff-4b35c1dcdbae81b75439ba570bc149554ca85b83757430613fcb612ae25972afR572-R579

```text
- name: "leaky_relu_yzh"
  signature: "Tensor (Tensor x, Float alpha) => LeakyReluYZH"
  bind_python: True
```

- 其中 `name` 表示导出到 Python 接口后函数的名字，比如导出后在 Python 下使用就是
```python
flow._C.leaky_relu_yzh(...)
```
- `signature` 用于描述接口原型及 C++ 代码的对应关系。`=>` 左边的为原型；`=>` 右边为对应的 Functional Library 中的名字。这里`LeakyRelu` 和前面导出时指定的字符串是一致的。
- `bind_python`，表示这个接口是否需要绑定 Python 接口 。比如下面的 `leaky_relu_grad`，我们不会在 Python 层用到（但会在 C++ 层求导使用），所以设置为 False。

完成以上工作后，新增的算子已经支持正向运算，编译好代码便可以进行如下简单的测试：

```python
import oneflow as flow 
import numpy as np


x_tensor = flow.Tensor(np.random.randn(3, 3))
out = flow._C.leaky_relu_yzh(x_tensor, alpha=0.2)
```

但是，还需要注册反向，才能支持反向传播。我们也先将反向需要的 `LeakyReluGrad` 导出为 functional 接口。

```cpp
- name: "leaky_relu_yzh_grad"
  signature: "Tensor (Tensor x, Tensor dy, Float alpha) => LeakyReluYZHGrad"
  bind_python: False
```

### 实现用于求导的反向逻辑

反向传播的本质就是高数中的链式法则，只不过 Autodiff 将链式法则变得模块化、易复用。

可以先阅读 [CSC321 Lecture 10: Automatic Differentiation
](https://www.cs.toronto.edu/~rgrosse/courses/csc321_2018/slides/lec10.pdf) 了解 autodiff 的基本概念。

从逻辑上而言，一个算子在反向过程中能够求导数，一般需要以下信息：

- 正向过程中的输入、输出
- 正向过程的 attr
- 反向过程中上一层（正向过程中的下一层）传递过来的正向输出的梯度

未来 Graph 模式和 Eager 模式下的反向逻辑会合并，但目前还是需要分别注册。

#### 为 Eager 模式注册反向

求导部分在 [oneflow/core/autograd/gradient_funcs/activation.cpp](https://github.com/Oneflow-Inc/oneflow/pull/8350/files#diff-36aeebf7fd5a8b88bd5af87774e7b0b4f76fed42cfb75044d6eebdfe65628347R213-R253) 完成

主要有以下几部分：

- LeakyReluYZHCaptureState ：用于存储数据的结构体

这是一个简单的结构体，继承自 `AutoGradCaptureState`，用于存储 op 的属性，以便于后续求导。

```cpp
struct LeakyReluYZHCaptureState  : public AutoGradCaptureState {
  bool requires_grad; // 输入x是否需要梯度
  float alpha=0.0; // 输入的参数alpha
};
```

- LeakyReluYZH 类：继承自 `OpExprGradFunction` 的类。需要重写三个函数：`Init`、`Capture`、`Apply`。

```cpp
class LeakyReluYZH : public OpExprGradFunction<LeakyReluYZHCaptureState> {
 public:
  Maybe<void> Init(const OpExpr& op) override {
    //...
  }

  Maybe<void> Capture(LeakyReluYZHCaptureState* ctx, const TensorTuple& inputs,
                      const TensorTuple& outputs, const AttrMap& attrs) const override {
    //...
  }

  Maybe<void> Apply(const LeakyReluYZHCaptureState* ctx, const TensorTuple& out_grads,
                    TensorTuple* in_grads) const override {
    //...
  }
};
```

- Init：做的是一些初始化的工作，可以根据前向 op 的配置，来初始化属性。

```cpp
  Maybe<void> Init(const OpExpr& op) override {
    const auto* fw_op_expr = dynamic_cast<const UserOpExpr*>(&op);
    CHECK_NOTNULL_OR_RETURN(fw_op_expr);
    base_attrs_ = MakeAttrMapFromUserOpConf(fw_op_expr->proto());
    return Maybe<void>::Ok();
  }
```

- Capture：用于捕捉前向的 Tensor，属性，用于后续的求导。

以 LeakyReluYZH 为例子，我们需要得到：a) 输入的 Tensor，当 Tensor 数值大于 0，梯度为 1，当小于 0，梯度为 alpha b) alpha的数值

```cpp
  Maybe<void> Capture(LeakyReluYZHCaptureState* ctx, const TensorTuple& inputs,
                      const TensorTuple& outputs, const AttrMap& attrs) const override {
    CHECK_EQ_OR_RETURN(inputs.size(), 1);                      // 判断输入个数是否为1
    ctx->requires_grad = inputs.at(0)->requires_grad();        // 判断输入是否需要梯度
    if (!ctx->requires_grad) { return Maybe<void>::Ok(); }     // 如果不需要梯度，也就不需要求导了，直接返回 Maybe<void>::Ok()

    ComposedAttrMap composed_attrs(attrs, base_attrs_);
    ctx->alpha = JUST(composed_attrs.GetAttr<float>("alpha")); // 获取 alpha，并存入 ctx->alpha 中
    ctx->SaveTensorForBackward(inputs.at(0));                  // 调用 SaveTensorForBackward 方法，保存输入的 Tensor
    return Maybe<void>::Ok();
  }
```

- Apply：实际计算梯度的函数，我们可以拿到先前的 Tensor，并调用 functional 接口下注册的 LeakyReluGrad，求得梯度，并返回

```cpp
  Maybe<void> Apply(const LeakyReluYZHCaptureState* ctx, const TensorTuple& out_grads,
                    TensorTuple* in_grads) const override {
    CHECK_EQ_OR_RETURN(out_grads.size(), 1);  // 检查梯度 Tensor 个数是否为 1
    in_grads->resize(1);                      // 因为输入只有一个，所以我们 resize(1)
    if (ctx->requires_grad) {
      const auto& x = ctx->SavedTensors().at(0); // 调用 SavedTensors 接口，拿到先前通过 SaveTensorForBackward 接口保存的 Tensor
      in_grads->at(0) = JUST(functional::LeakyReluYZHGrad(x, out_grads.at(0), ctx->alpha)); // 拿到 x，dy，alpha，传入给 LeakyReluYZHGrad 计算，并将梯度返回给 in_grads->at(0)
    }
    return Maybe<void>::Ok();
  }
```

最后一步是注册，第一个参数是 op type name，第二个参数是继承自 `OpExprGradFunction` 的类。

```cpp
REGISTER_OP_EXPR_GRAD_FUNCTION("leaky_relu_yzh", LeakyReluYZH); // 第二个参数是用于求导的类名
```

