## 反向传播
### 引言 
完成下面链接阅读，大致可以了解反向传播。

- [x] [BP 算法介绍](https://www.bilibili.com/video/BV19K4y1L7ao/?spm_id_from=333.788.recommend_more_video.1&vd_source=0a13fe290c31c25fa9f746838c074df4)
- [x] [[5分钟深度学习] #02 反向传播算法](https://www.bilibili.com/video/BV1yG411x7Cc/?spm_id_from=333.788&vd_source=0a13fe290c31c25fa9f746838c074df4)
- [x] [深度学习必会数学基础，计算图和求导的链式法则](https://www.bilibili.com/video/BV1bW4y1j77v/?spm_id_from=333.788.recommend_more_video.1&vd_source=0a13fe290c31c25fa9f746838c074df4)
- [x] [OneFlow源码解析：自动微分机制](https://zhuanlan.zhihu.com/p/587951710) 


## 结合一个Python示例研究 算子反向传播的实现 

假设您正在使用PyTorch实现exp2算子

$y_i = 2^{x_i}$

y对x求导 $y_i^, = 2^{x_i} * ln(2)$ 

（即对输入张量的每个元素进行2的指数幂运算），下面是两个一个简单的反向传播示例：


### 示例 1

```python
import torch
# 创建一个输入张量
x = torch.tensor([1.0, 2.0, 3.0], requires_grad=True)

# 创建exp2算子并计算前向传播
exp2 = torch.exp2
y = exp2(x)

# 计算梯度并打印结果
y.backward(torch.ones_like(x))
print(x.grad)
```
<details open>
<summary> output</summary>

```shell 
tensor([1.3863, 2.7726, 5.5452], dtype=oneflow.float32)
```
</details>

### 示例 2 

```python
import oneflow as torch
import math 

class Exp2Function(torch.autograd.Function):
    @staticmethod
    def forward(ctx, input):
        result = torch.pow(2, input)
        ctx.save_for_backward(result)
        return result

    @staticmethod
    def backward(ctx, grad_output):
        result, = ctx.saved_tensors
        return grad_output * math.log(2) * result

class Exp2(torch.nn.Module):
    def forward(self, input):
        return Exp2Function.apply(input)

# 创建一个输入张量
x = torch.tensor([1.0, 2.0, 3.0], requires_grad=True)

# 创建exp2算子并计算前向传播
exp2 = Exp2()
y = exp2(x)

# 计算梯度并打印结果
y.backward(torch.ones_like(x))
print(x.grad)
```

<details open>
<summary> output</summary>

```shell 
tensor([1.3863, 2.7726, 5.5452], dtype=oneflow.float32)
```
</details>

### oneflow 中 exp2反向实现逻辑 

https://github.com/youxiudeshouyeren/oneflow/blob/d1dc691308bf12fda90a48687e1693472b57eef2/oneflow/core/ep/common/primitive/binary_functor.h#L565-L571

```c++
template<DeviceType device, typename Src, typename Dst>
struct BinaryFunctor<device, BinaryOp::kExp2BackwardWithDyX, Src, Dst> {
  OF_DEVICE_FUNC BinaryFunctor(Scalar attr0, Scalar attr1) {}
  OF_DEVICE_FUNC Dst operator()(Src dy, Src x) const {
    return dy * exp2(x) * log(static_cast<Src>(2.0));
  }
};
```
这段代码定义了一个二元函数对象 BinaryFunctor，用于计算 exp2 函数的反向传播时对输入 dy 和 x 的导数。

具体来说，这个函数对象实现了 BinaryOp::kExp2BackwardWithDyX 操作，即对于输入的 dy 和 x，计算 exp2(x) 的导数乘以 dy，即 dy * exp2(x) * log(2)。其中，log(2) 是以 2 为底的对数，由于 log 函数并没有在 C++ 标准库中提供以 2 为底的版本，所以使用 static_cast<>() 函数将常数 2.0 转换为模板参数 Src 类型，然后再调用标准库中的 log 函数。