zhihu.db is where all the scraping results are stored.

Structure of database(Becasue the web-scraping started from bitcoin topic, so all tables are named bitcoin):

Top 5 rows of each table are shown below:

# topic_bitcoin

**Where evertything starts, choose a topic and scrape related aiticles/questions/answers:**

| thread_id | question_id         | answer_id | content_type | title  | content_href               | user_id                              | user_name                          | user_link     | upvote                                                    | record_date |           | 
|-----------|---------------------|-----------|--------------|--------|----------------------------|--------------------------------------|------------------------------------|---------------|-----------------------------------------------------------|-------------|-----------| 
| 1         | 275508580_397922150 | 275508580 | 397922150    | answer | 如何看待币圈四月底暴跌？               | /question/275508580/answer/397922150 | mei-you-si-xiang-de-yi-la-guan     | 没有思想的易拉罐      | //www.zhihu.com/people/mei-you-si-xiang-de-yi-la-guan     | 0           | 2018/5/21 | 
| 2         | 277975398_397920433 | 277975398 | 397920433    | answer | 如何看待阮一峰的博客攻击者比特币签名是ywwuyi？ | /question/277975398/answer/397920433 | NA                                 | 知乎用户          | NA                                                        | 0           | 2018/5/21 | 
| 3         | 277899814_397913242 | 277899814 | 397913242    | answer | 如何评价「比特币挖矿将令我们三年后无电可用？」？   | /question/277899814/answer/397913242 | wu-ding-he-78                      | 无定河           | //www.zhihu.com/people/wu-ding-he-78                      | 0           | 2018/5/21 | 
| 4         | 277061220_397900643 | 277061220 | 397900643    | answer | 二线城市投资比特币挖矿有前景吗？           | /question/277061220/answer/397900643 | leo-89-26-90                       | Leo           | //www.zhihu.com/people/leo-89-26-90                       | 0           | 2018/5/21 | 
| 5         | 277205083_397891691 | 277205083 | 397891691    | answer | 作为庄如何抬高自己发行的虚拟货币的价钱?       | /question/277205083/answer/397891691 | engineer-coin                      | Engineer Coin | //www.zhihu.com/people/engineer-coin                      | 0           | 2018/5/21 | 
| 6         | 49100704_397884584  | 49100704  | 397884584    | answer | 比特币交易平台哪个最靠谱？              | /question/49100704/answer/397884584  | zui-li-lun-dao-xing-shi-zhe-hua-19 | 醉里论道醒时折花      | //www.zhihu.com/people/zui-li-lun-dao-xing-shi-zhe-hua-19 | 5           | 2018/5/21 | 


# user_detail_bitcoin

# user_following_bitcoin

# follower_following_bitcoin
