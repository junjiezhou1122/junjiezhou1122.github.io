# Craft UI Spec Prompt

Craft UI 是一个手帐风的 Web UI 库，给人自然童趣的感觉。支持多主题，响应式，支持高度可定制化，在风格化和适用性上找到一个平衡点，需要比较容易对已有的网页做风格化

## 产出目标

- 定义一套 UI 风格的规范，包含字体，色彩、材质，光影明暗，卡片/容器、图标/贴纸、装饰、动画等
- 有一套风格转化 Prompt，可以把任意照片转换成和 UI 风格一致的图片
 - 会基于这套 Prompt 把小女孩照片转换成插图，基于插图做 IP 和逐帧动画
- 基于规范，制作一些 UI 组件库，方便直接使用
  - 有一个 Theme Panel 支持全局配置圆角，线条，颜色，材质等用来调整风格化程度
  - 除了 UI Components 本身，还需要提供一些 Helper/Utils 用来辅助创建新的组件，例如：动画、Filter、Noise, Container Path 等

## 设定与要求

- 色彩默认暖色手帐风，但是也要考虑蓝色海洋、绿色自然，白色冰雪等场景
- 手绘字体要支持中文，帮我想想标题，元信息，正文，按钮等用什么字体和字重
  - 大标题/Logo 用：文心喜乐体 (font-family: xile)，适合搭配不同颜色，描边一起使用
  - 小标题/正文用：素材集市康康体 (font-family: kangkang)，缺点是就单一字重，只能用浏览器模拟 Bold
- 关于图标选择，我不想用 Lucide，因为它不支持动画和填充模式，使用 Phosphor Icons + Lordicon
- 插图线稿和轮廓的笔刷用 6B Pencil/Technical Pen，填充颜色用 Dry Brush/Crayon/Chalk，背景和细节用 Charcoal/Noise Brush。整体会使用低 opacity 来叠层，不同颜色融合会用到 Smudge
- 容器线条 Border/Stroke 的粗细会有变化，并且随机有一些片段被裁减，营造一种不规则的感觉
- 材质有纸张，皮革，木纹，麻绳，石头，蕾丝/布艺，毛毡，叶脉/干花，贝壳/珍珠，陶土
  - 材质考虑到性能和兼容性，应该尽可能在全局使用一次，然后元素本身靠自己的 Path 来创造手绘感

## CraftShape 组件说明

图示：CraftShape 动画示例

参考 Rough.js 但不要线稿和素描的感觉，需要有彩铅颗粒和一些填充残缺

核心：这里形状 Path 是动态生成的 (通过 perfect-freehand 模拟压感和手工)，会包在一个普通 DOM 容器中，这样的好处是支持响应式，根据内容和参数动态变化

- 组件支持以下形状：
  - Blob，控制不同 blob 的半径
  - 矩形，线条可以控制略微倾斜
  - 圆角矩形，四个圆角不是完全一致
  - 圆圈，椭圆
  - 三角形
  - 五边形，六边形等
  - 五角星，六角星等，需要属性控制不同角之间的 Diff
- 组件属性：
  - Roughness
  - Bowing
  - FillStyle
  - 还有一些和形状相关的属性，比如 Blob 控制 blob 数量，圆角控制 radius
- 形状动画：
  - 支持形状之间的 Morph
  - 形状入场出场支持动态进入
  - 形状自身支持一些常见的 Idle 动画，比如 Spin, Swing, Floating, Twinkle 等

需要支持 Utils 对形状做 Boolean 运算来制作一些残缺感，比如容器边缘被采取一个小快，右下角被折起来了

跟形状配合的的还有 Filter + Noise(Random) + Motion，这几个要单独抽象出来后续复用，如果有其它特殊形状也能进行 Craftify

我后续还会组合不同 Shape + Gsap 动画形状更复杂的容器或效果，比如对话气泡，魔法棒星星

## CraftLine 组件说明
封装一些常见的线条，方便用来做装饰和连接元素

组件内置线条：
  - 直线，可以控制 strokeDasharray 虚线模拟，支持线条移动动画
  - 拱形曲线，可以控制曲率
  - 波浪曲线，类似 Sine, 可以控制频率，也能支持 Noise 不同峰值高度有差异
  - 圆圈线条，支持设置起始和终点线条（边段化），用来支持邮票齿边、弧形装饰
  - 任意不规则线条，这个应该需要从外部传入手绘 Points，然后进行转换，可以有一种手绘模式，收集后存起来传入到组件使用

组件属性：
  - 长度
  - 角度
  - 粗线
  - 颜色
  - 动画绘制等

还需要考虑如何在不同容器下控制尺寸用来适配宽度，比如我放置了一个文字下划线，需要根据文字的长度来进行适配，可能跟 viewBox 有关？

## CraftCursor 组件说明

这个组件是控制光标移动或者点击出现的效果，增添交互的趣味性
主要基于 Cursify 实现
希望做到以下效果：
- 如果特定元素调用 Trail Cursor，支持区域内在鼠标移动的时候出现，如果是自定义内容的效果，支持配置多个文字/Emoji/Icon
- 在按钮/点击中调用 Click Effects，出现预置的粒子效果，引入 Simplex Noise + Spring Easing 让效果更自然

## CraftPattern 组件说明

根据配置动态生成 SVG Pattern 独立展示，或者作为某个 SVG 的 Ref，也提供 Hook 可以已某种方式作为 CSS Background 展示

组件参数：
- pattern: Tile 基本形状，手帐常见图案，如：Dot, Circle, Cross, Memphis, Symbol(可以替换具体图形)
- 背景色
- 填充颜色
- 线条粗细
- 线条颜色
- Tile 尺寸
- Tile 间距
- Tile Offset
- Tile 朝向
- Randomness，值越大，这些属性会有偏差
- Scatter，
- [还有一些不同 Pattern 会有的特殊属性，我想 Tile 颜色属性是不是可以设置多个随机 Pick]

我想再配置一个参数实现那种 Scatter 分布，这样看起来会更有机一些。Tile 基本图形也可以支持 SVG 做更复杂的 Pattern，也方便我从外部 Pattern Generator 生成后粘贴进来

