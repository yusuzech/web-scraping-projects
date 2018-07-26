# usage_analysis_adnmb
This repo(moved from [here](https://github.com/yusuzech/usage_analysis_adnmb)) is currently in use for creating analysis for adnmb.com. A sample analysis(in Chinese) can be viewed [here](https://github.com/yusuzech/web-scraping-projects/blob/master/adnmb/analysis/adnmb_analysis.pdf)(open the file with browser for interactivity): The analysis covered top threads in each section and top threads in recent month. It also shows user activity on weekdays and hours of a day.


2018-04-20 update
------------------
Currently, adnmb tried to protect its website from being scraped and only allow user without account to view maximum 100 pages in each thread. So content in threads after 2018-04-18 will be missing if the maximum page is greater than 100 pages.

To solve this problem, one should apply for an account and login to view all pages.

# Folder Descriptions

1. MISC
  Some scripts to explore specific attributes of the website.
2. Analysis
  Used for produce report after getting scraping results.
3. debug
  Scripts used for debugging
4. functions
  Helpful functions used in other scripts
5. scrape
  scripts used for scraping the website.
  run `scrape/work.R` to run all other scraping scripts.
  
  
# features
  
  1. Easy to use, run `scrape/work.R` and wait for the result
  2. Results saved to csv files, easy to handle
  
# Potential Issues

1. Not using random user agent and proxy, can be easily detected or blocked.
2. Results saved to csv files, not easy to query
3. No code handling network issues.

# Takeaway from this project

1. Build more robust web-scraping scripts and prepare for encountering all kinds of possible failure(use user agent and proxy, atuo-retry failed requests etc.). I already employed those techniques in my [new project](https://github.com/yusuzech/web-scraping-projects/tree/master/zhihu) scraping zhihu.com.

# Improvements to be made

1. Use user agent and proxy, write codes guarding agains network issues.

# Conclusion

This is my first web-scraping project and I learned a lot from it. After many failures, I learned and successfully used techniques like using user agents, proxies and auto-retry failed requests. In my new projects, I saved data to database for better data management. Also, I learnt to use gmail api to send me eamil whenever failure occurs.
