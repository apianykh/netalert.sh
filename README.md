# NETALERT.SH

Some ugly bash scripts for personal use to monitor ISP Speed and IP address. Send notification to mobile devices through [pushover](https://pushover.net/)

## Scripts

 - ipaddr.sh - Track IP address changes using [ifconfig.co](https://ifconfig.co/)
 - speedtest.sh - Monitor ISP speed. Set SPEEDTEST_SERVER_ID in .env

## Dependencies
- curl
- jq
- [speedtest-cli](https://github.com/sivel/speedtest-cli)

## Usage

Just don't. But still you can add it as a cron job.

Copy .env.example file and change accordingly
```
# cp .env.example .env
```
Add jobs to crontab. For example:
```
0 10-20/5 * * * /home/user/netalert.sh/speedtest.sh > /dev/null
*/2 * * * * /home/user/netalert.sh/ipaddr.sh > /dev/null
```