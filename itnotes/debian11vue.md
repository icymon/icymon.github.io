## Debian安装Vue
### 一、安装Nodejs

> 参考:
> https://www.cnblogs.com/tangyouwei/p/10115548.html  

``` shell
# 下载二进制包  
sudo wget https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.xz
# 解压
sudo tar -xvf node-v18.12.1-linux-x64.tar.xz
```
* 设置环境变量

``` shell
sudo vim ~/.profile
```
加入如下内容  
```
#node
NODE_HOME=/xxx/xxx/xxx/node1812
PATH=$PATH:$NODE_HOME/bin
export PATH
```

* 查看安装的版本号

``` shell
node -v
```
* 安装脚手架及相关模块

``` shell
npm install -g vue-cli
npm install -g axios
npm install vue-router --save-dev # 路由
npm install --save element-plus

```

* 初始化和运行

``` shell
npm init vue@latest
npm install
npm run dev
```

* 整合element-plus

``` shell
npm install element-plus --save
```

> 1、在main.js中加入如下配置

```
// 新增代码：引入全部组件及样式
import ElementPlus from 'element-plus'
import '../node_modules/element-plus/theme-chalk/index.css'
// 新增代码：注册全部组件；即可在其它页面中直接使用全部组件
app.use(ElementPlus)
```

> 2、在页面中验证引用

```
 <el-button type="primary" @click="handleClick">Primary</el-button>
```

### 二、Vue中main.js和router/index.js配置举例

* main.js

```
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

import './assets/main.css'

// 新增代码：引入全部组件及样式
import ElementPlus from 'element-plus'
import '../node_modules/element-plus/theme-chalk/index.css'

const app = createApp(App)

app.use(router)
// 新增代码：注册全部组件；即可在其它页面中直接使用全部组件
app.use(ElementPlus)

app.mount('#app')
```

* index.js

```
import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import V_SysUserListPaged from '../views/V_SysUserListPaged.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/sysuser',
      name: 'sysuser',
      component: V_SysUserListPaged
    }
  ]
})

export default router
```
