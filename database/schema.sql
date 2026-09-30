-- =========================================================
-- Learnova AI Learning Platform - Database Schema v1
-- Target: PostgreSQL 15+ with pgvector (>= 0.5.0 for HNSW)
-- Source of truth: database/schema.dbml
-- =========================================================

CREATE EXTENSION IF NOT EXISTS vector;     -- pgvector: embeddings for RAG
-- gen_random_uuid() is built into PostgreSQL 13+

-- Keeps updated_at current on every UPDATE
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =========================================================
--  USERS & PROFILES
-- =========================================================

CREATE TABLE users (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email         varchar(255) NOT NULL UNIQUE,
  display_name  varchar(100),
  avatar_url    text,
  created_at    timestamp NOT NULL DEFAULT now(),
  updated_at    timestamp NOT NULL DEFAULT now()
);

CREATE TABLE user_profiles (
  user_id             uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  grade_level         varchar(50),
  country             varchar(100),
  language            varchar(20) DEFAULT 'en',
  timezone            varchar(100),
  learning_goal       text,
  daily_goal_minutes  int CHECK (daily_goal_minutes IS NULL OR daily_goal_minutes >= 0),
  created_at          timestamp NOT NULL DEFAULT now(),
  updated_at          timestamp NOT NULL DEFAULT now()
);


-- =========================================================
--  SUBJECT / CURRICULUM
-- =========================================================

CREATE TABLE subjects (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code         varchar(50) NOT NULL UNIQUE,
  name         varchar(100) NOT NULL,
  description  text,
  icon         varchar(255),
  is_active    boolean NOT NULL DEFAULT true,
  created_at   timestamp NOT NULL DEFAULT now(),
  updated_at   timestamp NOT NULL DEFAULT now()
);

CREATE TABLE curriculums (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id   uuid NOT NULL REFERENCES subjects(id),
  name         varchar(150) NOT NULL,
  description  text,
  grade_level  varchar(50),
  version      varchar(50),
  is_active    boolean NOT NULL DEFAULT true,
  created_at   timestamp NOT NULL DEFAULT now(),
  updated_at   timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_curriculums_subject_id ON curriculums(subject_id);

CREATE TABLE topics (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  curriculum_id  uuid NOT NULL REFERENCES curriculums(id) ON DELETE CASCADE,
  parent_id      uuid REFERENCES topics(id) ON DELETE CASCADE,
  name           varchar(150) NOT NULL,
  description    text,
  order_index    int,
  created_at     timestamp NOT NULL DEFAULT now(),
  updated_at     timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_topics_curriculum_id ON topics(curriculum_id);
CREATE INDEX idx_topics_parent_id     ON topics(parent_id);

CREATE TABLE lessons (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id           uuid NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  title              varchar(255) NOT NULL,
  description        text,
  order_index        int,
  estimated_minutes  int,
  is_active          boolean NOT NULL DEFAULT true,
  created_at         timestamp NOT NULL DEFAULT now(),
  updated_at         timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_lessons_topic_id ON lessons(topic_id);


-- =========================================================
--  SKILLS / KNOWLEDGE GRAPH
-- =========================================================

CREATE TABLE skills (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id   uuid NOT NULL REFERENCES subjects(id),
  topic_id     uuid REFERENCES topics(id) ON DELETE SET NULL,
  code         varchar(100) NOT NULL UNIQUE,
  name         varchar(200) NOT NULL,
  description  text,
  difficulty   decimal(5,2),
  skill_type   varchar(50),
  created_at   timestamp NOT NULL DEFAULT now(),
  updated_at   timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_skills_subject_id ON skills(subject_id);
CREATE INDEX idx_skills_topic_id   ON skills(topic_id);
CREATE INDEX idx_skills_skill_type ON skills(skill_type);

-- relationship_type: PREREQUISITE | RELATED | PART_OF
CREATE TABLE skill_relationships (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  from_skill_id      uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  to_skill_id        uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  relationship_type  varchar(50) NOT NULL,
  weight             decimal(5,2),
  created_at         timestamp NOT NULL DEFAULT now(),
  CONSTRAINT uq_skill_relationships UNIQUE (from_skill_id, to_skill_id),
  CONSTRAINT chk_skill_relationships_no_self CHECK (from_skill_id <> to_skill_id)
);
-- from_skill_id is covered by the unique index
CREATE INDEX idx_skill_relationships_to_skill_id ON skill_relationships(to_skill_id);
CREATE INDEX idx_skill_relationships_type        ON skill_relationships(relationship_type);

CREATE TABLE lesson_skills (
  lesson_id  uuid NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  skill_id   uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (lesson_id, skill_id)
);
CREATE INDEX idx_lesson_skills_skill_id ON lesson_skills(skill_id);


-- =========================================================
--  LEARNING CONTENT
-- =========================================================

-- content_type: EXPLANATION | EXAMPLE | GUIDED_PRACTICE | FLASHCARD | CHALLENGE | ...
CREATE TABLE content (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id         uuid NOT NULL REFERENCES subjects(id),
  topic_id           uuid REFERENCES topics(id) ON DELETE SET NULL,
  lesson_id          uuid REFERENCES lessons(id) ON DELETE SET NULL,
  content_type       varchar(50) NOT NULL,
  title              varchar(255) NOT NULL,
  description        text,
  body               text,
  difficulty         decimal(5,2),
  estimated_minutes  int,
  created_at         timestamp NOT NULL DEFAULT now(),
  updated_at         timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_content_subject_id   ON content(subject_id);
CREATE INDEX idx_content_topic_id     ON content(topic_id);
CREATE INDEX idx_content_lesson_id    ON content(lesson_id);
CREATE INDEX idx_content_content_type ON content(content_type);

CREATE TABLE content_skills (
  content_id  uuid NOT NULL REFERENCES content(id) ON DELETE CASCADE,
  skill_id    uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  importance  decimal(5,2),
  PRIMARY KEY (content_id, skill_id)
);
CREATE INDEX idx_content_skills_skill_id ON content_skills(skill_id);


-- =========================================================
--  QUESTIONS
-- =========================================================

CREATE TABLE questions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id     uuid NOT NULL REFERENCES subjects(id),
  skill_id       uuid REFERENCES skills(id) ON DELETE SET NULL,  -- primary skill
  question_type  varchar(50) NOT NULL,
  difficulty     decimal(5,2),
  question_text  text NOT NULL,
  explanation    text,
  answer_data    jsonb,
  metadata       jsonb,
  created_at     timestamp NOT NULL DEFAULT now(),
  updated_at     timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_questions_subject_id    ON questions(subject_id);
CREATE INDEX idx_questions_skill_id      ON questions(skill_id);
CREATE INDEX idx_questions_question_type ON questions(question_type);
CREATE INDEX idx_questions_difficulty    ON questions(difficulty);

CREATE TABLE question_skills (
  question_id  uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  skill_id     uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  weight       decimal(5,2) NOT NULL DEFAULT 1.0,
  PRIMARY KEY (question_id, skill_id)
);
CREATE INDEX idx_question_skills_skill_id ON question_skills(skill_id);

CREATE TABLE question_generations (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id          uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  model                varchar(100),
  prompt_version       varchar(50),
  generation_metadata  jsonb,
  quality_score        decimal(5,2),
  created_at           timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_question_generations_question_id ON question_generations(question_id);
CREATE INDEX idx_question_generations_model       ON question_generations(model);


-- =========================================================
--  PRACTICE / ASSESSMENT
-- =========================================================

CREATE TABLE practice_sessions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_id    uuid NOT NULL REFERENCES subjects(id),
  mode          varchar(50) NOT NULL,
  started_at    timestamp NOT NULL DEFAULT now(),
  completed_at  timestamp
);
CREATE INDEX idx_practice_sessions_user_id    ON practice_sessions(user_id);
CREATE INDEX idx_practice_sessions_subject_id ON practice_sessions(subject_id);
CREATE INDEX idx_practice_sessions_mode       ON practice_sessions(mode);
CREATE INDEX idx_practice_sessions_started_at ON practice_sessions(started_at);

CREATE TABLE question_attempts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id      uuid NOT NULL REFERENCES practice_sessions(id) ON DELETE CASCADE,
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question_id     uuid NOT NULL REFERENCES questions(id),
  answer_data     jsonb,
  is_correct      boolean,
  score           decimal(5,2),
  time_spent_ms   bigint,
  attempt_number  int DEFAULT 1,
  hints_used      int NOT NULL DEFAULT 0 CHECK (hints_used >= 0),
  confidence      smallint CHECK (confidence IS NULL OR confidence BETWEEN 1 AND 5),
  feedback        jsonb,  -- AI feedback / error analysis
  created_at      timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_question_attempts_session_id  ON question_attempts(session_id);
CREATE INDEX idx_question_attempts_user_id     ON question_attempts(user_id);
CREATE INDEX idx_question_attempts_question_id ON question_attempts(question_id);
CREATE INDEX idx_question_attempts_created_at  ON question_attempts(created_at);


-- =========================================================
--  USER SKILL MASTERY / SPACED REPETITION
-- =========================================================

-- status: NOT_STARTED | LEARNING | WEAK | MASTERED
CREATE TABLE user_skill_mastery (
  user_id          uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  skill_id         uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  mastery_score    decimal(5,4) NOT NULL DEFAULT 0 CHECK (mastery_score BETWEEN 0 AND 1),
  confidence       decimal(5,4) NOT NULL DEFAULT 0 CHECK (confidence BETWEEN 0 AND 1),
  attempt_count    int NOT NULL DEFAULT 0,
  correct_count    int NOT NULL DEFAULT 0,
  incorrect_count  int NOT NULL DEFAULT 0,
  last_attempt_at  timestamp,
  last_correct_at  timestamp,
  status           varchar(50) NOT NULL DEFAULT 'NOT_STARTED',
  created_at       timestamp NOT NULL DEFAULT now(),
  updated_at       timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, skill_id)
);
-- user_id is covered by the primary key
CREATE INDEX idx_user_skill_mastery_skill_id ON user_skill_mastery(skill_id);
CREATE INDEX idx_user_skill_mastery_status   ON user_skill_mastery(status);

CREATE TABLE skill_review_schedule (
  user_id           uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  skill_id          uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  due_at            timestamp NOT NULL,
  interval_days     decimal(8,2) NOT NULL DEFAULT 0,
  ease_factor       decimal(5,2) NOT NULL DEFAULT 2.5,
  repetitions       int NOT NULL DEFAULT 0,
  lapses            int NOT NULL DEFAULT 0,
  last_reviewed_at  timestamp,
  created_at        timestamp NOT NULL DEFAULT now(),
  updated_at        timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, skill_id)
);
CREATE INDEX idx_skill_review_schedule_user_due ON skill_review_schedule(user_id, due_at);


-- =========================================================
--  LEARNING GOALS / RECOMMENDATIONS / LEARNING PATHS
-- =========================================================

-- goal_type: EXAM | MASTERY | COURSE | CUSTOM
CREATE TABLE learning_goals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_id      uuid NOT NULL REFERENCES subjects(id),
  curriculum_id   uuid REFERENCES curriculums(id) ON DELETE SET NULL,
  goal_type       varchar(50) NOT NULL,
  title           varchar(255),
  target_grade    varchar(20),
  target_mastery  decimal(5,4) CHECK (target_mastery IS NULL OR target_mastery BETWEEN 0 AND 1),
  exam_name       varchar(255),
  exam_date       date,
  daily_minutes   int CHECK (daily_minutes IS NULL OR daily_minutes >= 0),
  study_schedule  jsonb,  -- preferred days / times
  status          varchar(50) NOT NULL DEFAULT 'ACTIVE',
  created_at      timestamp NOT NULL DEFAULT now(),
  updated_at      timestamp NOT NULL DEFAULT now(),
  completed_at    timestamp
);
CREATE INDEX idx_learning_goals_user_id    ON learning_goals(user_id);
CREATE INDEX idx_learning_goals_subject_id ON learning_goals(subject_id);
CREATE INDEX idx_learning_goals_status     ON learning_goals(status);

CREATE TABLE recommendations (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_id           uuid NOT NULL REFERENCES subjects(id),
  goal_id              uuid REFERENCES learning_goals(id) ON DELETE SET NULL,
  recommendation_type  varchar(50) NOT NULL,
  target_type          varchar(50) NOT NULL,  -- polymorphic: SKILL | CONTENT | QUESTION | LESSON | ...
  target_id            uuid,
  reason               jsonb,                 -- explainable recommendation
  priority             int DEFAULT 0,
  status               varchar(50) NOT NULL DEFAULT 'PENDING',
  created_at           timestamp NOT NULL DEFAULT now(),
  expires_at           timestamp,
  completed_at         timestamp
);
CREATE INDEX idx_recommendations_user_id    ON recommendations(user_id);
CREATE INDEX idx_recommendations_subject_id ON recommendations(subject_id);
CREATE INDEX idx_recommendations_type       ON recommendations(recommendation_type);
CREATE INDEX idx_recommendations_status     ON recommendations(status);
CREATE INDEX idx_recommendations_priority   ON recommendations(priority);

CREATE TABLE learning_paths (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  goal_id     uuid REFERENCES learning_goals(id) ON DELETE SET NULL,
  subject_id  uuid NOT NULL REFERENCES subjects(id),
  title       varchar(255),
  version     int NOT NULL DEFAULT 1,  -- incremented on re-plan
  status      varchar(50) NOT NULL DEFAULT 'ACTIVE',
  starts_on   date,
  ends_on     date,
  metadata    jsonb,
  created_at  timestamp NOT NULL DEFAULT now(),
  updated_at  timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_learning_paths_user_id ON learning_paths(user_id);
CREATE INDEX idx_learning_paths_goal_id ON learning_paths(goal_id);
CREATE INDEX idx_learning_paths_status  ON learning_paths(status);

-- item_type: LESSON | CONTENT | PRACTICE | REVIEW | ASSESSMENT
CREATE TABLE learning_path_items (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  path_id            uuid NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
  order_index        int NOT NULL,
  item_type          varchar(50) NOT NULL,
  skill_id           uuid REFERENCES skills(id) ON DELETE SET NULL,
  target_type        varchar(50),
  target_id          uuid,
  recommendation_id  uuid REFERENCES recommendations(id) ON DELETE SET NULL,
  scheduled_date     date,
  estimated_minutes  int,
  status             varchar(50) NOT NULL DEFAULT 'PENDING',
  started_at         timestamp,
  completed_at       timestamp,
  created_at         timestamp NOT NULL DEFAULT now(),
  updated_at         timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_learning_path_items_path_order     ON learning_path_items(path_id, order_index);
CREATE INDEX idx_learning_path_items_skill_id       ON learning_path_items(skill_id);
CREATE INDEX idx_learning_path_items_scheduled_date ON learning_path_items(scheduled_date);
CREATE INDEX idx_learning_path_items_status         ON learning_path_items(status);


-- =========================================================
--  ASSESSMENTS (DIAGNOSTIC / EXAM)
-- =========================================================

-- assessment_type: DIAGNOSTIC | PRACTICE_EXAM | TIMED_EXAM | MOCK_EXAM
CREATE TABLE assessments (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id          uuid NOT NULL REFERENCES subjects(id),
  curriculum_id       uuid REFERENCES curriculums(id) ON DELETE SET NULL,
  created_by          uuid REFERENCES users(id) ON DELETE SET NULL,
  assessment_type     varchar(50) NOT NULL,
  title               varchar(255) NOT NULL,
  description         text,
  time_limit_seconds  int,
  is_adaptive         boolean NOT NULL DEFAULT false,
  config              jsonb,
  is_active           boolean NOT NULL DEFAULT true,
  created_at          timestamp NOT NULL DEFAULT now(),
  updated_at          timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_assessments_subject_id ON assessments(subject_id);
CREATE INDEX idx_assessments_type       ON assessments(assessment_type);

CREATE TABLE assessment_questions (
  assessment_id  uuid NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  question_id    uuid NOT NULL REFERENCES questions(id),
  order_index    int,
  points         decimal(6,2) NOT NULL DEFAULT 1,
  PRIMARY KEY (assessment_id, question_id)
);
CREATE INDEX idx_assessment_questions_question_id ON assessment_questions(question_id);

CREATE TABLE assessment_attempts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id  uuid NOT NULL REFERENCES assessments(id),
  user_id        uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id     uuid UNIQUE REFERENCES practice_sessions(id) ON DELETE SET NULL,
  goal_id        uuid REFERENCES learning_goals(id) ON DELETE SET NULL,
  status         varchar(50) NOT NULL DEFAULT 'IN_PROGRESS',
  score          decimal(6,2),
  max_score      decimal(6,2),
  skill_results  jsonb,  -- per-skill evidence / initial mastery map
  started_at     timestamp NOT NULL DEFAULT now(),
  submitted_at   timestamp,
  created_at     timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_assessment_attempts_assessment_id ON assessment_attempts(assessment_id);
CREATE INDEX idx_assessment_attempts_user_id       ON assessment_attempts(user_id);
CREATE INDEX idx_assessment_attempts_status        ON assessment_attempts(status);


-- =========================================================
--  AI TUTOR / CONVERSATIONS
-- =========================================================

CREATE TABLE conversations (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_id  uuid REFERENCES subjects(id) ON DELETE SET NULL,
  title       varchar(255),
  created_at  timestamp NOT NULL DEFAULT now(),
  updated_at  timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_conversations_user_id    ON conversations(user_id);
CREATE INDEX idx_conversations_subject_id ON conversations(subject_id);
CREATE INDEX idx_conversations_updated_at ON conversations(updated_at);

CREATE TABLE messages (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id  uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  role             varchar(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system', 'tool')),
  content          text NOT NULL,
  metadata         jsonb,
  created_at       timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_messages_conversation_created ON messages(conversation_id, created_at);


-- =========================================================
--  FILE UPLOADS / RAG / KNOWLEDGE BASE
-- =========================================================

-- source_type: PDF | IMAGE | NOTE | HANDWRITING | AUDIO
CREATE TABLE attachments (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  source_type        varchar(50) NOT NULL,
  file_name          varchar(255) NOT NULL,
  mime_type          varchar(100) NOT NULL,
  size_bytes         bigint,
  storage_key        text NOT NULL,  -- object storage key
  processing_status  varchar(50) NOT NULL DEFAULT 'PENDING',
  extracted_text     text,
  metadata           jsonb,
  created_at         timestamp NOT NULL DEFAULT now(),
  updated_at         timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_attachments_user_id           ON attachments(user_id);
CREATE INDEX idx_attachments_processing_status ON attachments(processing_status);

CREATE TABLE message_attachments (
  message_id     uuid NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
  attachment_id  uuid NOT NULL REFERENCES attachments(id) ON DELETE CASCADE,
  PRIMARY KEY (message_id, attachment_id)
);
CREATE INDEX idx_message_attachments_attachment_id ON message_attachments(attachment_id);

CREATE TABLE documents (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id     uuid REFERENCES subjects(id) ON DELETE SET NULL,
  topic_id       uuid REFERENCES topics(id) ON DELETE SET NULL,
  user_id        uuid REFERENCES users(id) ON DELETE CASCADE,  -- NULL = shared/curated
  attachment_id  uuid REFERENCES attachments(id) ON DELETE SET NULL,
  content_type   varchar(50),
  title          varchar(255) NOT NULL,
  source         varchar(255),
  source_url     text,
  metadata       jsonb,
  created_at     timestamp NOT NULL DEFAULT now(),
  updated_at     timestamp NOT NULL DEFAULT now()
);
CREATE INDEX idx_documents_subject_id   ON documents(subject_id);
CREATE INDEX idx_documents_topic_id     ON documents(topic_id);
CREATE INDEX idx_documents_user_id      ON documents(user_id);
CREATE INDEX idx_documents_content_type ON documents(content_type);

-- Embedding dimension must match the embedding model (1536 = e.g. text-embedding-3-small)
CREATE TABLE document_chunks (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id  uuid NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  content      text NOT NULL,
  chunk_index  int NOT NULL,
  embedding    vector(1536),
  metadata     jsonb,
  created_at   timestamp NOT NULL DEFAULT now(),
  CONSTRAINT uq_document_chunks_index UNIQUE (document_id, chunk_index)
);
-- Approximate nearest-neighbour search (cosine distance: embedding <=> query)
CREATE INDEX idx_document_chunks_embedding
  ON document_chunks USING hnsw (embedding vector_cosine_ops);


-- =========================================================
--  GAMIFICATION / ACTIVITY
-- =========================================================

CREATE TABLE achievements (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code         varchar(100) NOT NULL UNIQUE,
  name         varchar(150) NOT NULL,
  description  text,
  criteria     jsonb,
  created_at   timestamp NOT NULL DEFAULT now()
);

CREATE TABLE user_achievements (
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  achievement_id  uuid NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  earned_at       timestamp NOT NULL DEFAULT now(),
  metadata        jsonb,
  PRIMARY KEY (user_id, achievement_id)
);
CREATE INDEX idx_user_achievements_achievement_id ON user_achievements(achievement_id);

-- Source for streaks, daily goals, XP totals and weekly progress
CREATE TABLE user_daily_activity (
  user_id             uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  activity_date       date NOT NULL,
  minutes_studied     int NOT NULL DEFAULT 0,
  questions_answered  int NOT NULL DEFAULT 0,
  correct_answers     int NOT NULL DEFAULT 0,
  skills_reviewed     int NOT NULL DEFAULT 0,
  xp_earned           int NOT NULL DEFAULT 0,
  goal_met            boolean NOT NULL DEFAULT false,
  created_at          timestamp NOT NULL DEFAULT now(),
  updated_at          timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, activity_date)
);


-- =========================================================
--  updated_at TRIGGERS
-- =========================================================

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'users', 'user_profiles', 'subjects', 'curriculums', 'topics', 'lessons',
    'skills', 'content', 'questions', 'user_skill_mastery', 'skill_review_schedule',
    'learning_goals', 'learning_paths', 'learning_path_items', 'assessments',
    'conversations', 'attachments', 'documents', 'user_daily_activity'
  ]
  LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%1$s_updated_at BEFORE UPDATE ON %1$I
         FOR EACH ROW EXECUTE FUNCTION set_updated_at()', t);
  END LOOP;
END $$;
