#22-schema_update_24.sql
CREATE SEQUENCE "augur_data"."message_sentiment_msg_analysis_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE SEQUENCE "augur_data"."message_sentiment_summary_msg_summary_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE TABLE "augur_data"."message_sentiment" (
  "msg_analysis_id" int8 NOT NULL DEFAULT nextval('"augur_data".message_sentiment_msg_analysis_id_seq'::regclass),
  "msg_id" int8,
  "worker_run_id" int8,
  "sentiment_score" float8,
  "reconstruction_error" float8,
  "novelty_flag" bool,
  "feedback_flag" bool,
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "message_sentiment_pkey" PRIMARY KEY ("msg_analysis_id")
)
;

ALTER TABLE "augur_data"."message_sentiment" OWNER TO "augur";

COMMENT ON COLUMN "augur_data"."message_sentiment"."worker_run_id" IS 'This column is used to indicate analyses run by a worker during the same execution period, and is useful for grouping, and time series analysis.  ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."sentiment_score" IS 'A sentiment analysis score. Zero is neutral, negative numbers are negative sentiment, and positive numbers are positive sentiment. ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."reconstruction_error" IS 'Each message is converted to a 250 dimensin doc2vec vector, so the reconstruction error is the difference between what the predicted vector and the actual vector.';

COMMENT ON COLUMN "augur_data"."message_sentiment"."novelty_flag" IS 'This is an analysis of the degree to which the message is novel when compared to other messages in a repository.  For example when bots are producing numerous identical messages, the novelty score is low. It would also be a low novelty score when several people are making the same coment. ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."feedback_flag" IS 'This exists to provide the user with an opportunity provide feedback on the resulting the sentiment scores. ';

CREATE TABLE "augur_data"."message_sentiment_summary" (
  "msg_summary_id" int8 NOT NULL DEFAULT nextval('"augur_data".message_sentiment_summary_msg_summary_id_seq'::regclass),
  "repo_id" int8,
  "worker_run_id" int8,
  "positive_ratio" float8,
  "negative_ratio" float8,
  "novel_count" int8,
  "period" timestamp(0),
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "message_sentiment_summary_pkey" PRIMARY KEY ("msg_summary_id")
)
;

ALTER TABLE "augur_data"."message_sentiment_summary" OWNER TO "augur";

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."worker_run_id" IS 'This value should reflect the worker_run_id for the messages summarized in the table. There is not a relation between these two tables for that purpose because its not *really*, relationaly a concept unless we create a third table for "worker_run_id", which we determined was unnecessarily complex. ';

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."novel_count" IS 'The number of messages identified as novel during the analyzed period';

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."period" IS 'The whole timeline is divided into periods based on the definition of time period for analysis, which is user specified. Timestamp of the first period to look at, until the end of messages at the data of execution. ';

COMMENT ON TABLE "augur_data"."message_sentiment_summary" IS 'In a relationally perfect world, we would have a table called “message_sentiment_run” the incremented the “worker_run_id” for both message_sentiment and message_sentiment_summary. For now, we decided this was overkill. ';

SELECT setval('"augur_data"."message_sentiment_msg_analysis_id_seq"', 1, false);

ALTER SEQUENCE "augur_data"."message_sentiment_msg_analysis_id_seq"
OWNED BY "augur_data"."message_sentiment"."msg_analysis_id";

ALTER SEQUENCE "augur_data"."message_sentiment_msg_analysis_id_seq" OWNER TO "augur";

SELECT setval('"augur_data"."message_sentiment_summary_msg_summary_id_seq"', 1, false);

ALTER SEQUENCE "augur_data"."message_sentiment_summary_msg_summary_id_seq"
OWNED BY "augur_data"."message_sentiment_summary"."msg_summary_id";

ALTER SEQUENCE "augur_data"."message_sentiment_summary_msg_summary_id_seq" OWNER TO "augur";

--

CREATE SEQUENCE "augur_data"."repo_topic_repo_topic_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE SEQUENCE "augur_data"."topic_words_topic_words_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE TABLE "augur_data"."repo_topic" (
  "repo_topic_id" int8 NOT NULL DEFAULT nextval('"augur_data".repo_topic_repo_topic_id_seq'::regclass),
  "repo_id" int4,
  "topic_id" int4,
  "topic_prob" float8,
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "repo_topic_pkey" PRIMARY KEY ("repo_topic_id")
)
;

CREATE TABLE "augur_data"."topic_words" (
  "topic_words_id" int8 NOT NULL DEFAULT nextval('"augur_data".topic_words_topic_words_id_seq'::regclass),
  "topic_id" int4,
  "word" varchar COLLATE "pg_catalog"."default",
  "word_prob" float8,
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "topic_words_pkey" PRIMARY KEY ("topic_words_id")
)
;

SELECT setval('"augur_data"."repo_topic_repo_topic_id_seq"', 14655, true);

ALTER SEQUENCE "augur_data"."repo_topic_repo_topic_id_seq"
OWNED BY "augur_data"."repo_topic"."repo_topic_id";

SELECT setval('"augur_data"."topic_words_topic_words_id_seq"', 25, true);

ALTER SEQUENCE "augur_data"."topic_words_topic_words_id_seq"
OWNED BY "augur_data"."topic_words"."topic_words_id";

CREATE INDEX "cntrb_id" ON "augur_data"."contributors" USING hash (
  "cntrb_email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);


---
--- Message Sentiment and Novelty
---
CREATE SEQUENCE "augur_data"."message_sentiment_msg_analysis_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE SEQUENCE "augur_data"."message_sentiment_summary_msg_summary_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE TABLE "augur_data"."message_sentiment" (
  "msg_analysis_id" int8 NOT NULL DEFAULT nextval('"augur_data".message_sentiment_msg_analysis_id_seq'::regclass),
  "msg_id" int8,
  "worker_run_id" int8,
  "sentiment_score" float8,
  "reconstruction_error" float8,
  "novelty_flag" bool,
  "feedback_flag" bool,
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "message_sentiment_pkey" PRIMARY KEY ("msg_analysis_id")
)
;

COMMENT ON COLUMN "augur_data"."message_sentiment"."worker_run_id" IS 'This column is used to indicate analyses run by a worker during the same execution period, and is useful for grouping, and time series analysis.  ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."sentiment_score" IS 'A sentiment analysis score. Zero is neutral, negative numbers are negative sentiment, and positive numbers are positive sentiment. ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."reconstruction_error" IS 'Each message is converted to a 250 dimensin doc2vec vector, so the reconstruction error is the difference between what the predicted vector and the actual vector.';

COMMENT ON COLUMN "augur_data"."message_sentiment"."novelty_flag" IS 'This is an analysis of the degree to which the message is novel when compared to other messages in a repository.  For example when bots are producing numerous identical messages, the novelty score is low. It would also be a low novelty score when several people are making the same coment. ';

COMMENT ON COLUMN "augur_data"."message_sentiment"."feedback_flag" IS 'This exists to provide the user with an opportunity provide feedback on the resulting the sentiment scores. ';

CREATE TABLE "augur_data"."message_sentiment_summary" (
  "msg_summary_id" int8 NOT NULL DEFAULT nextval('"augur_data".message_sentiment_summary_msg_summary_id_seq'::regclass),
  "repo_id" int8,
  "worker_run_id" int8,
  "positive_ratio" float8,
  "negative_ratio" float8,
  "novel_count" int8,
  "period" timestamp(0),
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "message_sentiment_summary_pkey" PRIMARY KEY ("msg_summary_id")
)
;

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."worker_run_id" IS 'This value should reflect the worker_run_id for the messages summarized in the table. There is not a relation between these two tables for that purpose because its not *really*, relationaly a concept unless we create a third table for "worker_run_id", which we determined was unnecessarily complex. ';

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."novel_count" IS 'The number of messages identified as novel during the analyzed period';

COMMENT ON COLUMN "augur_data"."message_sentiment_summary"."period" IS 'The whole timeline is divided into periods based on the definition of time period for analysis, which is user specified. Timestamp of the first period to look at, until the end of messages at the data of execution. ';

COMMENT ON TABLE "augur_data"."message_sentiment_summary" IS 'In a relationally perfect world, we would have a table called “message_sentiment_run” the incremented the “worker_run_id” for both message_sentiment and message_sentiment_summary. For now, we decided this was overkill. ';

SELECT setval('"augur_data"."message_sentiment_msg_analysis_id_seq"', 12089, true);

ALTER SEQUENCE "augur_data"."message_sentiment_msg_analysis_id_seq"
OWNED BY "augur_data"."message_sentiment"."msg_analysis_id";

SELECT setval('"augur_data"."message_sentiment_summary_msg_summary_id_seq"', 206, true);

ALTER SEQUENCE "augur_data"."message_sentiment_summary_msg_summary_id_seq"
OWNED BY "augur_data"."message_sentiment_summary"."msg_summary_id";

CREATE INDEX "cntrb_id" ON "augur_data"."contributors" USING hash (
  "cntrb_email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);


--
--- LSTM Models
--

CREATE SEQUENCE "augur_data"."lstm_anomaly_models_model_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE SEQUENCE "augur_data"."lstm_anomaly_results_result_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

CREATE TABLE "augur_data"."lstm_anomaly_models" (
  "model_id" int8 NOT NULL DEFAULT nextval('"augur_data".lstm_anomaly_models_model_id_seq'::regclass),
  "model_name" varchar COLLATE "pg_catalog"."default",
  "model_description" varchar COLLATE "pg_catalog"."default",
  "look_back_days" int8,
  "training_days" int8,
  "batch_size" int8,
  "metric" varchar COLLATE "pg_catalog"."default",
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "lstm_anomaly_models_pkey" PRIMARY KEY ("model_id")
)
;

ALTER TABLE "augur_data"."lstm_anomaly_models" OWNER TO "augur";

CREATE TABLE "augur_data"."lstm_anomaly_results" (
  "result_id" int8 NOT NULL DEFAULT nextval('"augur_data".lstm_anomaly_results_result_id_seq'::regclass),
  "repo_id" int8,
  "repo_category" varchar COLLATE "pg_catalog"."default",
  "model_id" int8,
  "metric" varchar COLLATE "pg_catalog"."default",
  "contamination_factor" float8,
  "mean_absolute_error" float8,
  "remarks" varchar COLLATE "pg_catalog"."default",
	"metric_field" varchar COLLATE "pg_catalog"."default",
  "mean_absolute_actual_value" float8,
  "mean_absolute_prediction_value" float8,
  "tool_source" varchar COLLATE "pg_catalog"."default",
  "tool_version" varchar COLLATE "pg_catalog"."default",
  "data_source" varchar COLLATE "pg_catalog"."default",
  "data_collection_date" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "lstm_anomaly_results_pkey" PRIMARY KEY ("result_id")
)
;

ALTER TABLE "augur_data"."lstm_anomaly_results" OWNER TO "augur";

COMMENT ON COLUMN "augur_data"."lstm_anomaly_results"."metric_field" IS 'This is a listing of all of the endpoint fields included in the generation of the metric. Sometimes there is one, sometimes there is more than one. This will list them all. ';

ALTER TABLE "augur_data"."lstm_anomaly_results" ADD CONSTRAINT "fk_lstm_anomaly_results_lstm_anomaly_models_1" FOREIGN KEY ("model_id") REFERENCES "augur_data"."lstm_anomaly_models" ("model_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "augur_data"."lstm_anomaly_results" ADD CONSTRAINT "fk_lstm_anomaly_results_repo_1" FOREIGN KEY ("repo_id") REFERENCES "augur_data"."repo" ("repo_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

SELECT setval('"augur_data"."lstm_anomaly_models_model_id_seq"', 11, true);

ALTER SEQUENCE "augur_data"."lstm_anomaly_models_model_id_seq"
OWNED BY "augur_data"."lstm_anomaly_models"."model_id";

ALTER SEQUENCE "augur_data"."lstm_anomaly_models_model_id_seq" OWNER TO "augur";

SELECT setval('"augur_data"."lstm_anomaly_results_result_id_seq"', 37, true);

ALTER SEQUENCE "augur_data"."lstm_anomaly_results_result_id_seq"
OWNED BY "augur_data"."lstm_anomaly_results"."result_id";

ALTER SEQUENCE "augur_data"."lstm_anomaly_results_result_id_seq" OWNER TO "augur";

--
---
--


update "augur_operations"."augur_settings" set value = 24 where setting = 'augur_data_version'; 
