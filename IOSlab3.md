### IOS智能应用开发lab2

202220013徐简

#### 实验结果：

1. 请基于模板工程，为[https://itsc.nju.edu.cn开发一个iOS客户端。](https://itsc.nju.edu.xn--cnios-hg1hyj621byvrd3h48ivn1f./)

   功能要求如下：

   1. App界面设计见模板工程的Main Storyboard，首届面通过tab bar controller分为5个栏目
   2. 前4个分别对应网站4个信息栏目（如下），下载list.htm内容并将新闻条目解析显示在Table View中
      - https://itsc.nju.edu.cn/xwdt/list.htm
      - https://itsc.nju.edu.cn/tzgg/list.htm
      - https://itsc.nju.edu.cn/wlyxqk/list.htm
      - https://itsc.nju.edu.cn/aqtg/list.htm
   3. 点击table view中任意一个cell，获取该cell对应新闻的详细内容页面，解析内容并展示在内容详情场景中
   4. 最后一个栏目显示 https://itsc.nju.edu.cn/main.htm 最后“关于我们”部分的信息

效果如下：

![Screen Shot 2021-11-18 at 23.50.48](/Users/kirakiraakira/Desktop/Screen Shot 2021-11-18 at 23.50.48.png)

![Screen Shot 2021-11-18 at 23.51.01](/Users/kirakiraakira/Desktop/Screen Shot 2021-11-18 at 23.51.01.png)

#### 代码结构

- 网络爬虫部分从GitHub导入了Swiftsoup，用起来和python的BeautifulSoup差不多，没有遇到什么问题，除了导入Xcode导入库一直网络失败（还好最后奇迹般成功了XD 校园网yyds）
- 总体的思路是，从html中解析出总页数maxpageNum，然后修改相应的URL，访问URL获取HTML代码，解析得到需要的Table Cell信息
- GCD并发参考PPT
- Segue的切换，将被点击的cell中的URL信息传送到下一个View，类似地可以获取详情的信息

#### 功能展示

见录屏

#### 感想与体会

- 没有老师的示例视频，开发难度直线上升
- GCD并发编程遇到了不少奇怪的bug，缓冲问题有的还没解决好
- 界面切换到详细信息的时候，遇到了一个奇怪的错误，折腾了半天也没解决，后来重新一比一复刻了一个，竟然没问题orz