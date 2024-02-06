# Github仓库注意事项

在创建Framework中，将代码上传到Githu的过程中，遇到一些问题，记录如下：

1.提示`remote: Support for password authentication was removed on August 13, 2021.`

>  remote: Support for password authentication was removed on August 13, 2021.

> remote: Please see https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.

> fatal: Authentication failed for 'https://github.com/winfredzen/CocoapodsFrameworkTest.git/'

如果使用的是https这种形式拉取的代码，则会提示如上

但如果是ssh形式的，则不会有如上的问题



2.Github SSH的生成

这个网上有大量的资料，如：

+ [Github配置ssh key的步骤（大白话+包含原理解释）](https://blog.csdn.net/weixin_42310154/article/details/118340458)

如果需要配置多个SSH Key，可参考：

+ [如何用 SSH 密钥在一台机器上管理多个 GitHub 账户](https://www.freecodecamp.org/chinese/news/manage-multiple-github-accounts-the-ssh-way/)

生成新的key后，**在 ssh-agent 上注册新的 SSH 密钥**

```shell
ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa_work_user1
```



配置完后，使用`ssh -T git@github.com`验证SSH是否配置成功

