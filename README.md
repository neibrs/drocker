
单容器式集成环境，包含LAMP环境，Drupal环境包；本库用于Neibrs一站式环境代码。

|- drocker                一站式集成LAMP环境
|- drupal                 Drupal文件编译容器
|- nginx                  用于服务器上多容器或单容器时，设定反向代理站点服务

**Notice** 如果开发Drupal项目，请按下面的步骤:
* sh drupal/build.sh   ## 生成drupal代码文件

Drupal代码文件在生成的web目录下，这样就可以开始开发项目了........
