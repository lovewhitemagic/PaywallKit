# PaywallKit

一个简单灵活的 SwiftUI 订阅付费墙 UI 组件，仅负责展示，适配你的 StoreKit / RevenueCat 逻辑。

![preview](https://github.com/lovewhitemagic/PaywallKit/assets/preview.png)

---

## ✨ 特点

- ✅ 支持任意数量的订阅选项（例如月/年/买断）
- ✅ 自定义权益说明 / 按钮文案 / 底部协议链接
- ✅ 暗色模式支持
- ✅ 独立于逻辑层，可与 StoreKit2 / RevenueCat 搭配
- ✅ 可用于 `.sheet` 弹窗或完整页面

---

## 🧩 安装方式（Swift Package）

在 Xcode 中选择：File > Add Packages...输入：
https://github.com/lovewhitemagic/PaywallKit.git
即可引入。

---

## 🚀 使用示例

```swift
import PaywallKit

struct ContentView: View {
    @State private var showSheet = false
    @State private var selectedID = "year"

    var body: some View {
        Button("打开订阅页面") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            ProPaywallView(
                title: "订阅会员专享权益",
                features: [
                    "多设备同步", "无限制添加记录", "导出报表"
                ],
                options: [
                    PaywallOption(id: "month", title: "月订阅", priceText: "US$0.99/月"),
                    PaywallOption(id: "year", title: "年订阅", subtitle: "节省 50%", priceText: "US$6.99/年"),
                    PaywallOption(id: "lifetime", title: "买断", priceText: "US$19.99")
                ],
                selectedID: selectedID,
                onSelect: { selectedID = $0.id },
                onSubscribe: { selected in
                    // 调用你的购买逻辑
                    showSheet = false
                },
                policyLinks: [
                    ("隐私政策", URL(string: "https://example.com/privacy")!),
                    ("使用条款", URL(string: "https://example.com/terms")!)
                ],
                onClose: { showSheet = false },
                onRestore: {
                    print("恢复购买逻辑")
                }
            )
        }
    }
}

