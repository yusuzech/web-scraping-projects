## Project Description
This repository contains scripts to scrape user's followees and user's information. When given a topic id, users information related with that topic will be scraped. Also, information of user's followees can be scraped. This scraping process can be runned recursively.

## Concept Explanations

The general idea is: give any user_token, The script can scrape the user's information and that user's followee.(The picture below shows what is user token in zhihu)

![user_token](www/Inkeduser_token_LI.jpg)



## Descriptions for each file:
1. get_user_info_json.R
  Given a user token, scrape that user's personal information like number of upvotes, nubmer of answers, education etc. It's named json because the script uses a hidden json from the request.

2. get_following.R
  Given a user token, returns all users that user is following. 

3. working.R
  Combine other scripts together: scrape and store results in SQLite database. Current code in this file use the topic "bitcoin" as a start. just change the topic id, database names and variable names, it works for any other topic.

4. get topic.R
  Given a topic id, returns questions, answers and related user information in a table. It is used as intial input to get users related to the topic.

5. loop_user_info.R
  This function is build upon get_user_info_json.R and adds auto-retry feature. Whenever scraper failed to extract information from a user.

6. db_remove_duplicate.R

   Web-scraping database is different from normal one. For the sake of speed, it's better to just append new observations to database. But it creates duplications as we can scrape a user multiple times if that user appears multiple times. So after scraping, we need to remove all duplicates.

7. write_2_db.R

   write scraping results to local SQLite database.

## Features

1. Uses random user agent and random IP while making requests.
1. Uses zhihu's hidden api file, avoid parsing failures from changes in HTML.
2. Auto retry whenever there is failure, default set to 3 times.
3. Auto retry after all items in list are completed. So it won't send request to the same url frequently.
4. Print output as scraping goes, easy to detect failure and estimate completing time.
5. Saved to databse frequently, won't lose any scraping results.

## Potential Issues

1. Scriptes vulnarable to changes in zhihu's hidden api.
3. If all auto-retries failed, information of those failures are not recorded. I attemped to capture and save all failures but it failed somehow.
4. I used proxy with the while scraping, but it will throw an error if proxy is not provided. This problem is not fixed yet.(It's still strongly recommended to use proxy)  
5.Because the 25 proxies I used fall into a same ip range. After sending 600,000 requests in a day, it was considered umhanme by zhihu server and got blocked. It is better to use more proxy in a wider ip range.

![user_token](www/unhuman.PNG)

## Takeaway from this Project

1. Prepare for network issues
2. Prepare for non-network failures, returns are different, other part of codes may fail.
3. Ensure consitancy all the times, while encoutering issues, fixing  them on the spot may be a quick way. But too many quick fixings like that makes it very hard to deug.
4. Prepare for network issues is easy. The hard part is to deal with unpredictable results brought by network issues.
5. Not only just skip failed request but also record them. So we can categorize them and write better exception handling method.
6. Don't assign values in functions globally, it's a dirty way and it may fail. When doing error handling, after printing error message just return NULL or NA. Check for NULL or NA and doing record them outside the function.


## Improvement to be Made

1. When doing auto-retries, ensure consistancy(not only make scripts work but also make them look good).
2. When debuging, make debug codes look good(make them work is not good enough).
3. Use gmail api to send me email to report process and errors
5. Parallel requests and make it much faster. Currently it takes 1~2 seconds for each request.

## Conclusion

Though the scripts have some minor issues, they work robustly. I ran it to get 10,000 users'  information and their 400,000 followee without encoutering any errors.

If you have are any issues, feel free to contact me on github. 
