--------------------------------------------------------
--  File created - Thursday-April-21-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table OCCURENCES
--------------------------------------------------------

  CREATE TABLE "CVP45F"."OCCURENCES" 
   (	"OCCURENCE" NUMBER(*,0), 
	"HEADID" NUMBER(*,0), 
	"TAILID" NUMBER(*,0), 
	"FREQUENCY" NUMBER(*,0), 
	"SUBREDDITID" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table REDDITCOMMENT
--------------------------------------------------------

  CREATE TABLE "CVP45F"."REDDITCOMMENT" 
   (	"COMMENTID" NUMBER(*,0), 
	"TEXT" VARCHAR2(2000 BYTE), 
	"VOTES" NUMBER(*,0), 
	"ANALYZED" NUMBER(1,0), 
	"SUBREDDITID" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SUBREDDIT
--------------------------------------------------------

  CREATE TABLE "CVP45F"."SUBREDDIT" 
   (	"SUBREDDITID" NUMBER(*,0), 
	"SUBREDDITNAME" VARCHAR2(24 BYTE), 
	"RUNNING_VOTE_SQ" NUMBER(*,0), 
	"RUNNING_VOTE" NUMBER(*,0), 
	"NUMBEROFCOMMENTS" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table WORDHEAD
--------------------------------------------------------

  CREATE TABLE "CVP45F"."WORDHEAD" 
   (	"HEADID" NUMBER(*,0), 
	"WORD1" VARCHAR2(30 BYTE), 
	"WORD2" VARCHAR2(30 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table WORDTAIL
--------------------------------------------------------

  CREATE TABLE "CVP45F"."WORDTAIL" 
   (	"TAILID" NUMBER(*,0), 
	"WORD" VARCHAR2(30 BYTE)
   ) ;
--------------------------------------------------------
--  Constraints for Table OCCURENCES
--------------------------------------------------------

  ALTER TABLE "CVP45F"."OCCURENCES" MODIFY ("HEADID" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."OCCURENCES" MODIFY ("TAILID" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."OCCURENCES" MODIFY ("FREQUENCY" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."OCCURENCES" MODIFY ("SUBREDDITID" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."OCCURENCES" ADD PRIMARY KEY ("OCCURENCE")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table REDDITCOMMENT
--------------------------------------------------------

  ALTER TABLE "CVP45F"."REDDITCOMMENT" MODIFY ("TEXT" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."REDDITCOMMENT" MODIFY ("VOTES" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."REDDITCOMMENT" MODIFY ("ANALYZED" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."REDDITCOMMENT" MODIFY ("SUBREDDITID" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."REDDITCOMMENT" ADD PRIMARY KEY ("COMMENTID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SUBREDDIT
--------------------------------------------------------

  ALTER TABLE "CVP45F"."SUBREDDIT" MODIFY ("SUBREDDITNAME" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."SUBREDDIT" MODIFY ("RUNNING_VOTE_SQ" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."SUBREDDIT" MODIFY ("RUNNING_VOTE" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."SUBREDDIT" MODIFY ("NUMBEROFCOMMENTS" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."SUBREDDIT" ADD PRIMARY KEY ("SUBREDDITID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table WORDHEAD
--------------------------------------------------------

  ALTER TABLE "CVP45F"."WORDHEAD" MODIFY ("WORD1" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."WORDHEAD" MODIFY ("WORD2" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."WORDHEAD" ADD PRIMARY KEY ("HEADID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table WORDTAIL
--------------------------------------------------------

  ALTER TABLE "CVP45F"."WORDTAIL" MODIFY ("WORD" NOT NULL ENABLE);
  ALTER TABLE "CVP45F"."WORDTAIL" ADD PRIMARY KEY ("TAILID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table OCCURENCES
--------------------------------------------------------

  ALTER TABLE "CVP45F"."OCCURENCES" ADD FOREIGN KEY ("HEADID")
	  REFERENCES "CVP45F"."WORDHEAD" ("HEADID") ENABLE;
  ALTER TABLE "CVP45F"."OCCURENCES" ADD FOREIGN KEY ("TAILID")
	  REFERENCES "CVP45F"."WORDTAIL" ("TAILID") ENABLE;
  ALTER TABLE "CVP45F"."OCCURENCES" ADD FOREIGN KEY ("SUBREDDITID")
	  REFERENCES "CVP45F"."SUBREDDIT" ("SUBREDDITID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table REDDITCOMMENT
--------------------------------------------------------

  ALTER TABLE "CVP45F"."REDDITCOMMENT" ADD FOREIGN KEY ("SUBREDDITID")
	  REFERENCES "CVP45F"."SUBREDDIT" ("SUBREDDITID") ENABLE;
