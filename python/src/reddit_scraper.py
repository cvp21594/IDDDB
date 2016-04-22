#!/usr/bin/env python3
import praw
import database

class RedditScraper:
    REDDIT_USER_AGENT = "linux:com.devito:v1.0 (by /u/chasecaleb)"
    SUBREDDITS = "coffee+beer+wine+scotch+bourbon"

    _db = None
    _submissions = None
    _inserted_subreddits = 0
    _inserted_submissions = 0
    _inserted_comments = 0

    def __init__(this):
        this._db = database.Database()
        this._submissions = this._submission_generator()

    def _process_comment(this, comment):
        if isinstance(comment, praw.objects.MoreComments):
            return
        if this._db.row_exists("comments", "comment_id", comment.fullname):
            print("Skipping existing comment:", comment.fullname)
            return

        params = {
            "COMMENT_ID": comment.fullname,
            "PARENT_COMMENT_ID": comment.parent_id if not comment.is_root else None,
            "SUBMISSION_ID": comment.submission.fullname,
            "CONTENT": comment.body,
            "VOTES": comment.score,
            "ANALYZED": False
            }
        this._db.insert("comments", params)
        this._inserted_comments += 1

    def _process_submission(this, submission):
        if this._db.row_exists("submissions", "submission_id", submission.fullname):
            return

        params = {
            "SUBMISSION_ID": submission.fullname,
            "SUBREDDIT_ID": submission.subreddit.fullname,
            "VOTES": submission.score,
            "TITLE": submission.title,
            "SELF_POST": submission.is_self,
            "CONTENT": submission.selftext if submission.is_self else submission.url
            }
        this._db.insert("submissions", params)
        this._inserted_submissions += 1

    def _process_subreddit(this, subreddit):
        if this._db.row_exists("subreddits", "subreddit_id", subreddit.fullname):
            return

        params = {
            "subreddit_id": subreddit.fullname,
            "name": subreddit.display_name,
            "subscriber_count": subreddit.subscribers
            }
        this._db.insert("subreddits", params)
        this._inserted_subreddits += 1

    def _submission_generator(this):
        reddit = praw.Reddit(user_agent = this.REDDIT_USER_AGENT)
        subreddit = reddit.get_subreddit(this.SUBREDDITS)
        stream = subreddit.get_top_from_all(limit = None)
        while True:
            yield from stream

    def run(this):
        try:
            last_commit_at = 0
            while True:
                submission = next(this._submissions)
                this._process_subreddit(submission.subreddit)
                this._process_submission(submission)
                submission.replace_more_comments()
                comments = praw.helpers.flatten_tree(submission.comments)
                for c in comments:
                    this._process_comment(c)

                if this._insert_total() >= last_commit_at + 500:
                    last_commit_at = this._insert_total()
                    this._db.commit()
                    this._print_summary()
        except KeyboardInterrupt:
            print("Committing...")
            this._db.commit()
            print("Quitting...")

    def _insert_total(this):
        return this._inserted_comments + this._inserted_submissions + this._inserted_subreddits

    def _print_summary(this):
        print("INSERTS:")
        print("\t{:15s}: {}".format("Total: ", this._insert_total()))
        print("\t{:15s}: {}".format("Subreddits: ", this._inserted_subreddits))
        print("\t{:15s}: {}".format("Submissions: ", this._inserted_submissions))
        print("\t{:15s}: {}".format("Comments: ", this._inserted_comments))
        print("")
