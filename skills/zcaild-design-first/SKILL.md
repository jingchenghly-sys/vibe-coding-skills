---
name: zcaild-design-first
display_name: 设计先行
display_name_en: Design First
description: >-
  Design first. Before writing UI code, generate a visual, interactive
  design-spec page (color, type, spacing, radius, shadow, components, usage
  rules, design variables, handoff info, and an automatic check that text is
  readable) and use it as the only visual source for later development, so
  writing the screen directly does not leave it plain, inconsistent, or
  off-palette. Use when starting a new GUI, web, mini program, mobile or
  desktop app, or landing page; when the user mentions a design system, design
  spec, UI spec, visual style, design tokens, or style guide; or when they say
  a page looks plain, ugly, or inconsistent. Do not use for backend-only work,
  CLI tools, or when a mature design system already exists and the task is only
  to implement it.
description_zh: 设计先行。在 AI 写界面代码之前，先生成一份可视化、可交互的设计规范页（色彩、字体、间距圆角阴影、组件、使用规则、设计变量、交付信息，并自动检查文字是否清晰可读），作为后续开发的唯一视觉依据，避免直接写代码导致页面单调、风格不统一、配色不达标。适用于开始做新的 GUI / Web / 小程序 / 移动端 / 桌面应用或落地页，用户提到设计系统、设计规范、UI 规范、视觉风格、design tokens、style guide，或抱怨页面太素、不好看、不统一时。不适用于纯后端、命令行工具或已有成熟设计系统只需按规范实现的场景。
description_en: >-
  Design first. Before writing UI code, generate a visual, interactive
  design-spec page (color, type, spacing, radius, shadow, components, usage
  rules, design variables, handoff info, and an automatic check that text is
  readable) and use it as the only visual source for later development, so
  writing the screen directly does not leave it plain, inconsistent, or
  off-palette. Use when starting a new GUI, web, mini program, mobile or
  desktop app, or landing page; when the user mentions a design system, design
  spec, UI spec, visual style, design tokens, or style guide; or when they say
  a page looks plain, ugly, or inconsistent. Do not use for backend-only work,
  CLI tools, or when a mature design system already exists and the task is only
  to implement it.
category: design
version: 1.1.0
author: 志成AI落地
---

# 设计先行

在写任何业务界面之前，先产出一份**可视化、可交互、由 token 驱动**的设计规范页，后续开发全部引用其中的 token。

## 能力边界

- **能做**：从品牌素材（设计稿导出、官网、截图）提取或从一个主色推导整套 token；生成单文件 HTML 规范页，含可交互组件、后台文字可读性检查和可复制的 CSS 变量；指导后续开发只引用 token。
- **不做**：不生成业务页面本身；不替用户修改品牌方给定的颜色（只给出不达标项和建议色值）；不引入外部依赖或安装任何软件。

模板：[templates/design-system.html](templates/design-system.html)（「志成 AI 落地」浅色品牌示例，取值来自 zcaild.com，可直接打开查看效果）。
规范细则：[reference.md](reference.md)。

## 工作流

```
- [ ] 1. 收集输入
- [ ] 2. 推导 token
- [ ] 3. 生成规范页
- [ ] 4. 浏览器验证
- [ ] 5. 导出 token 并交付
```

### 1. 收集输入

先从对话和仓库里推断；推断不出来的，一次性向用户问完（有选择题工具时优先用选择题）：

- 产品类型与核心场景（决定要展示哪些组件）
- 平台：移动端 / 桌面端 / Web（决定画板宽度、组件高度）
- 主题：深色 / 浅色
- 品牌色或情绪关键词；是否需要品牌渐变
- 已有素材：Figma 导出的 SVG/CSS、截图、竞品、已有 `tokens.css`

如果用户提供了设计稿导出物（如 Figma 的 SVG + CSS），以导出 CSS 中的数值为准，SVG 只用来看布局（SVG 里的文字通常已转成路径，无法直接读取）。

### 2. 推导 token

按 [reference.md](reference.md) 的「必备 token」清单补齐，每个 token 都要有**用途说明**。原则：

- 有品牌素材时：只提取、不改编，缺失的状态才推导，并在页面标「补充」
- 没有品牌素材时：按 reference.md「没有品牌素材时怎么定」从一个主色推导整套，避开 AI 默认风格
- 颜色按角色命名（`--color-primary`、`--color-text-secondary`），不要按色相命名（`--purple`）
- 字号 6–7 级，字重最多 3 种
- 组件尺寸（输入框高、按钮高、圆角）也是 token
- 不要凭感觉判断文字是否清晰可读，以第 4 步页面计算结果为准

### 3. 生成规范页

1. 复制模板到目标项目：`design/design-system.html`（若项目已有设计目录则放那里）
2. **只改 `:root` 里的 token 值**来换肤，页面其余样式都引用变量
3. 按 7 个编号区块替换内容（结构见 reference.md「页面结构」）：
   - 01 色彩、02 字体：色号、变量名、应用说明与 `:root` 保持一致，示例文案换成该产品的真实文案
   - 03 间距、圆角与阴影：样本与变量一一对应
   - 04 基础组件：保留适用组件，删掉不适用的，补上该产品的核心组件（见 reference.md 的组件清单）
   - 05 设计说明与使用规则：按该产品重写 6 张规则卡，写具体数字和禁止项
   - 07 交付信息：填写版本、来源、确认状态
   - 脚本里的 `CONTRAST_PAIRS`：登记该产品所有「文字色 × 背景色」组合，用于后台检查文字可读性
4. 每个组件必须：有可交互的真实 demo + 旁边的标注列表（`属性：值` 格式），标注写全所有状态

### 4. 浏览器验证

起本地静态服务（如 `python3 -m http.server`）打开页面，检查：

- 桌面宽度下布局与原稿/预期一致，截图给用户看
- 360px 宽度无横向溢出（`document.documentElement.scrollWidth === innerWidth`）
- 交互状态可用：输入框聚焦描边、清空按钮、按钮禁用态、导航切换
- 顶部锚点导航能跳到 7 个区块，滚动时高亮当前区块
- 07 交付信息的「待处理（文字可读性）」：自己推导的颜色出现在这里，就按建议色值改 `:root` 并刷新，直到只剩品牌给定的颜色；交付时把剩余项用一句话告诉用户，由用户决定是否采用建议值
- 06 设计变量：全部变量都归入了分组，没有出现「其他」分组

页面不依赖任何外部库，只需要能打开浏览器；无法起服务时可直接用浏览器打开 HTML 文件。

### 5. 导出 token 并交付

- 用页面上的「复制 CSS 变量」按钮，或直接复制 `:root` 块，写入 `design/tokens.css`
- 在项目规则或 README 中写明：**UI 代码只能引用 `tokens.css` 中的变量，禁止硬编码色值/字号/圆角**
- 若项目用 Tailwind，把 token 映射进 `theme.extend`（颜色、字号、圆角、高度）

## 后续开发时

- 实现任何界面前先打开 `design/design-system.html` 对照
- 新组件先加进规范页（demo + 标注），再在业务代码里使用
- 修改视觉只改 token，再刷新规范页确认整体效果
