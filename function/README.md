
## These functions are utily functions that facilitate web-scraping process.

All these functions are imported from this [repo](https://github.com/yusuzech/r-web-scraping-template):
1. html_session_try.R  
  wrapper function build on  `html_session()` function in rvest package. Add auto retry funcionality. Ruturn NA if all requests failed.
2. random_agent.R  
  Use random user agent.
3. rotate_proxy.R  
  Rotate a proxy table.
4. html_session_null.R  
  Same functionality as html_session_try.R but returns null if all requests fail.
