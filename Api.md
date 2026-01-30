# info.json API — 项目选择器（示例 / 演示）

## 基本说明
- 所有接口均以 `/api/` 为前缀（服务器已配置为使用该前缀）。

## JSON 模式（info.json）
- `uuid`: 字符串（RFC UUID）
- `name`: 字符串
- `createdAt`: ISO-8601 UTC 时间字符串
- `updatedAt`: ISO-8601 UTC 时间字符串
- `note`: 字符串


## JSON 模式（project.json）
- `uuid`: UUID（和文件夹名称保持一致）
- `raw`: png、npz、dcm、nii、false（是否上传raw源文件）
- `nii`: true、false、raw（是否转为nii，raw为png）
- `dcm`: true、false、raw（是否转为dcm，raw为png）
- `semi`: true、false（是否增强）
- `semi-xL`: int（-1为不修改）（增强后取用的x轴像素的起始点）
- `semi-xR`: int（-1为不修改）（增强后取用的x轴像素的起终点）
- `semi-yL`: int（-1为不修改）（增强后取用的y轴像素的起始点）
- `semi-yR`: int（-1为不修改）（增强后取用的y轴像素的起终点）
- `PD`: false、raw、semi（是否经过推理，raw使用raw进行推理、semi使用增强过的文件进行推理）
- `PD-nii`: true、false（推理后文件是否转为nii，每次推理时删除转换后文件并改为false）
- `PD-dcm`: true、false（推理后文件是否转为dcm，每次推理时删除转换后文件并改为false）
- `PD-3d`: true、false（是否生成3d文件，每次推理时删除转换后文件并改为false）

## 接口列表

1) 列表 — 获取所有项目
- 方法：GET /api/projects/info.json
- 返回：200，JSON 数组，按 `updatedAt` 降序排序
- 示例：`[]` 或 `[ {"uuid":"...","name":"..."} ]`

2) 获取单个项目
- 方法：GET /api/projects/{uuid}
- 返回：200（项目对象）
- 未找到：404，`{ "error": "project not found" }`

3) 删除项目
- 方法：DELETE /api/projects/{uuid}
- 返回：200 或 204（幂等）
- 未找到：404

4) 新建项目
- 方法：POST /api/projects
- 请求体：`{ "name": "string", "note": "string" }`
- 返回：201，创建的项目对象（包含 `uuid`、`createdAt`、`updatedAt`）
- 错误：400（无效请求体）

5) 修改备注（专用接口）
- 方法：PATCH /api/projects/{uuid}/note
- 请求体：`{ "note": "string" }`
- 返回：200，更新后的项目对象
- 未找到：404

## 请求/响应头
- 请求：POST/PATCH 请使用 `Content-Type: application/json`
- 响应：`Content-Type: application/json`
- CORS（开发环境）：`Access-Control-Allow-Origin: *`

## 磁盘存储布局
- `db/info.json` — 单一 JSON 数组文件，包含所有项目对象（首次运行时自动创建）。
- `db/{uuid}/project.json` — 项目创建时生成，记录项目处理相关状态。

## 本地快速上手
- 构建：在项目根目录运行 `./BuildmacOS.sh`
- 启动：`./main`
- 快速验证：运行 `./tests/manual_info_api.sh`

## 注意与限制
- 示例级别的持久化：使用单文件 JSON 存储，若有多进程并发访问需谨慎。
- 列表按 `updatedAt` 降序返回。
- 本示例不包含认证（仅用于本地/演示）。
