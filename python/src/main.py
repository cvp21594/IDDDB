#!/usr/bin/env python3
import praw

REDDIT_USER_AGENT = "linux:com.devito:v1.0 (by /u/chasecaleb)"

def init_reddit():
    username = input("Reddit username: ")
    password = input("Reddit password: ")
    return praw.Reddit(user_agent = REDDIT_USER_AGENT)

def main():
    reddit = init_reddit()

def __main__:
    main()
