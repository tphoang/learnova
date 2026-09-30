# Learnova vs Astra AI — Gap Analysis & Next Plan

**Purpose:** Compare the current Learnova concept with Astra AI and define the next product priorities.

**Important:** This document is a product/feature comparison based on publicly presented Astra AI capabilities. It is not intended to copy Astra's implementation or assume capabilities that Astra has not publicly documented.

---

# 1. Executive Summary

Astra AI demonstrates that an AI learning product can combine:

- AI tutoring;
- uploaded learning material;
- learning paths;
- quizzes and exercises;
- flashcards;
- repetition;
- knowledge-gap identification;
- exam preparation;
- mock exams;
- image-based learning;
- interactive simulations;
- teacher and parent workflows.

Learnova's original concept already has a strong foundation:

```text
AI Tutor
+
Knowledge Graph
+
Skill Tracking
+
Recommendation
```

The main gap is that Learnova's earlier MVP was too narrow:

```text
Chat
Practice
Skill Tracking
```

The next version should become:

```text
Goal
 ↓
Diagnostic Assessment
 ↓
Knowledge Graph
 ↓
Skill Mastery
 ↓
Knowledge Gaps
 ↓
Adaptive Recommendation
 ↓
Learning Path
 ↓
Daily Learning
 ↓
Practice
 ↓
Assessment
 ↓
Re-plan
```

The most important next step is therefore **not to copy every Astra feature**.

The priority should be to build Learnova's underlying **adaptive learning engine** deeply, starting with Chemistry.

---

# 2. High-Level Comparison

| Capability | Learnova | Astra AI | Learnova Next Step |
|---|---|---|---|
| AI Tutor | Planned / core | Yes | Keep |
| Chemistry-first | Yes | Multi-subject | Keep as differentiation |
| Knowledge Graph | Core architecture | Public implementation details unclear | Make it real |
| Skill mastery | Core architecture | Knowledge-gap / mastery-oriented | Deepen |
| Recommendation | Planned | Yes | Build adaptive engine |
| Learning path | Planned | Yes | High priority |
| Goal / target | Planned | Yes | High priority |
| Diagnostic assessment | Planned | Learning assessment features | High priority |
| PDF / notes input | Planned | Yes | High priority |
| Image input | Planned | Yes | High priority |
| Handwriting | Roadmap | Image-based workflows | Later |
| Quiz | Yes | Yes | Keep |
| Practice | Yes | Yes | Keep |
| Flashcards | Planned | Yes | P1 |
| Spaced repetition | Planned | Yes | P1 |
| Knowledge gaps | Planned | Yes | P0 |
| Exam mode | Planned | Yes | P1 |
| Mock exam | Planned | Yes | P1 |
| Oral exam | Future | Yes | P2 |
| Voice tutor | Future | Yes / related workflows | P2 |
| Interactive simulation | Chemistry roadmap | Yes | P2, Chemistry-specific |
| Gamification | Roadmap | Yes | P1/P2 |
| Parent tools | Future | Yes | P2 |
| Teacher tools | Future | Yes | P2 |
| Classroom | Future | Teacher-oriented | P2 |
| Podcast | Not priority | Yes | P3 |
| Multi-subject | Future | Yes | Later |

---

# 3. What Astra Shows Us

Astra's product direction indicates that students benefit from an integrated learning workflow rather than an isolated chatbot.

The relevant pattern is:

```text
Student Material
      ↓
AI Understanding
      ↓
Learning Plan
      ↓
Lesson
      ↓
Practice
      ↓
Review
      ↓
Knowledge Gap
      ↓
Exam Preparation
```

This validates several Learnova decisions:

- AI Tutor is useful but insufficient by itself.
- Practice must be connected to learning state.
- Personalization needs structured student data.
- Study plans should be goal-driven.
- Exam preparation should eventually be part of the same system.

---

# 4. Major Learnova Gaps

## 4.1 Learning Goal

Learnova should explicitly model:

- subject;
- target grade;
- target mastery;
- exam;
- exam date;
- available study time;
- preferred learning schedule.

Example:

```text
Goal
 ├── Chemistry
 ├── Target grade: 8/10
 ├── Exam date: 21 days
 ├── Available time: 30 min/day
 └── Target mastery: 80%
```

---

## 4.2 Diagnostic Assessment

The system needs to determine the student's starting point.

```text
Diagnostic Test
      ↓
Skill Evidence
      ↓
Initial Mastery Map
      ↓
Knowledge Gaps
```

Without diagnostic assessment, the recommendation engine has incomplete information.

---

## 4.3 Knowledge Gap Engine

This should become a core Learnova service.

Example:

```text
Stoichiometry
      ↑
Chemical Ratios       48%
      ↑
Mole Calculation      80%
      ↑
Mole Concept          95%
```

The system should identify **Chemical Ratios** as a likely bottleneck rather than simply recommending more Stoichiometry questions.

This is where Learnova's Knowledge Graph becomes operationally important.

---

## 4.4 Adaptive Learning Path

Learnova should turn the skill state into an ordered plan.

```text
Current State
     ↓
Prerequisite Analysis
     ↓
Prioritize Gaps
     ↓
Generate Path
     ↓
Daily Activities
     ↓
Measure
     ↓
Re-plan
```

A learning path should change when the student improves or struggles.

---

## 4.5 Multi-Format Learning

A single skill should support multiple activity types:

```text
Skill
 ├── Explanation
 ├── Example
 ├── Guided Practice
 ├── MCQ
 ├── Short Answer
 ├── Flashcard
 ├── Review
 └── Challenge
```

This allows the platform to select the appropriate activity for the learner's current state.

---

# 5. Features Learnova Should Add

## P0 — Critical

### 1. Learning Goals

### 2. Diagnostic Assessment

### 3. Knowledge Gap Engine

### 4. Adaptive Recommendation

### 5. Learning Path

### 6. PDF / Notes / Image ingestion

### 7. AI-generated lessons

### 8. AI-generated practice

### 9. Chemistry Knowledge Graph

### 10. Skill mastery engine

These features form the actual adaptive-learning foundation.

---

# 6. P1 — Important

After the adaptive engine works:

### Flashcards

Generate cards directly from skills and learning material.

### Spaced Repetition

Connect reviews to skill mastery.

### Exam Mode

```text
Practice Exam
Timed Exam
Mock Exam
```

### Daily Study Plan

```text
Today
 ├── Review 2 skills
 ├── Learn 1 concept
 ├── Practice 10 questions
 └── Complete 1 challenge
```

### Gamification

Focus on:

- mastery;
- consistency;
- improvement;
- completed learning goals.

---

# 7. P2 — Differentiation

## Chemistry Interactive Learning

Instead of simply matching generic AI-learning features, Learnova should exploit its Chemistry-first strategy.

### Molecule Visualization

```text
Molecule
 ↓
Atoms
 ↓
Bonds
 ↓
Geometry
 ↓
Interactive exploration
```

### Virtual Experiments

Example:

```text
Experiment
 ↓
Change concentration
 ↓
Observe outcome
 ↓
Predict
 ↓
Explain
```

### Chemistry Problem Understanding

Input:

```text
Photo of handwritten chemistry problem
```

Pipeline:

```text
Image
 ↓
OCR / Chemistry extraction
 ↓
Structured problem
 ↓
Skill identification
 ↓
Solution
 ↓
Explanation
 ↓
Mastery evidence
```

This connects the input system directly to the learning engine.

---

# 8. Parent and Teacher Layer

Astra demonstrates that education products can extend beyond the individual learner.

Learnova can later provide:

## Parent

```text
Student
 ↓
Progress
 ↓
Mastery
 ↓
Weak Skills
 ↓
Study Consistency
```

## Teacher

```text
Class
 ↓
Skill Heatmap
 ↓
Common Gaps
 ↓
Assignments
 ↓
Student Progress
```

The teacher experience should use Learnova's Knowledge Graph and mastery data instead of creating a separate analytics system.

---

# 9. What NOT to Prioritize

Learnova should not attempt to implement every feature at once.

Lower priority:

- Podcast
- Large social/community features
- Full classroom ecosystem
- Many subjects at launch
- Advanced voice features
- Complex gamification
- Large-scale simulation library

The initial product should prove the adaptive learning loop.

---

# 10. Proposed Learnova Product Loop

This should become the core product architecture:

```text
                    STUDENT
                       │
                       ▼
               ┌──────────────┐
               │     GOAL     │
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │  DIAGNOSTIC  │
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │ KNOWLEDGE KG │
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │    MASTERY   │
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │ KNOWLEDGE GAP│
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │ RECOMMENDER  │
               └──────┬───────┘
                      ↓
               ┌──────────────┐
               │ LEARNING PATH│
               └──────┬───────┘
                      ↓
          ┌───────────┴───────────┐
          ↓                       ↓
       AI TUTOR                PRACTICE
          │                       │
          └───────────┬───────────┘
                      ↓
                  ATTEMPT
                      ↓
                 NEW EVIDENCE
                      │
                      └──────────────→ MASTERY
```

This loop is more important than any individual feature.

---

# 11. Next Technical Plan

## Step 1 — Freeze the Domain Model

Finalize:

```text
Subject
Curriculum
Topic
Lesson
Skill
Skill Relation
Content
Question
Attempt
User Skill Mastery
Learning Goal
Learning Path
Recommendation
Review Schedule
Exam
```

---

## Step 2 — Build Chemistry Knowledge Graph

Start small.

Target an initial set of high-quality skills and prerequisite relationships.

Do not start by trying to model every Chemistry concept.

Quality of relationships matters more than raw skill count.

---

## Step 3 — Build Mastery Engine

Input:

```text
Attempt
```

Output:

```text
Skill Mastery
```

The first implementation can be rules-based.

Later, the model can become more sophisticated.

---

## Step 4 — Build Knowledge Gap Engine

Input:

```text
Mastery
+
Skill Relations
+
Recent Attempts
```

Output:

```text
Critical Knowledge Gaps
```

---

## Step 5 — Build Recommendation Engine

Input:

```text
Goal
+
Mastery
+
Knowledge Gaps
+
Prerequisites
+
Review Schedule
```

Output:

```text
Next Best Learning Activity
```

---

## Step 6 — Build Learning Path

Convert recommendations into:

```text
Goal
 ↓
Weekly Plan
 ↓
Daily Plan
 ↓
Activities
```

The plan must be dynamically updated.

---

## Step 7 — Connect AI Tutor

The tutor should have access to:

```text
Student
+
Current Skill
+
Mastery
+
Knowledge Gap
+
Learning Path
+
Relevant Content
```

This makes the tutor personalized.

---

# 12. Proposed MVP 2.0 Architecture

```text
                 React Native
                      │
                      ▼
                  FastAPI
                      │
      ┌───────────────┼────────────────┐
      │               │                │
      ▼               ▼                ▼
 AI Tutor       Learning Engine    Content/RAG
      │               │                │
      │        ┌──────┼───────┐        │
      │        │      │       │        │
      │        ▼      ▼       ▼        │
      │     Mastery  Gaps  Recommend   │
      │               │                │
      │               ▼                │
      │         Learning Path          │
      │               │                │
      └───────────────┼────────────────┘
                      ▼
              PostgreSQL + pgvector
```

---

# 13. Database Changes Needed

The existing generalized schema should be extended with explicit entities for the new adaptive-learning layer.

Important additions / confirmations:

```text
learning_goals
learning_paths
learning_path_items
recommendations
user_skill_mastery
skill_review_schedule
diagnostic_assessments
assessment_attempts
```

Existing core entities remain:

```text
subjects
topics
lessons
skills
skill_relations
content
questions
answers
practice_sessions
attempts
users
profiles
attachments
conversations
messages
```

---

# 14. Suggested Release Plan

## Release 0.1 — Chemistry Tutor

```text
Authentication
Chat
Chemistry content
Basic questions
Basic practice
```

## Release 0.2 — Skill Intelligence

```text
Skills
Knowledge Graph
Attempts
Mastery
Basic knowledge gaps
```

## Release 0.3 — Adaptive Learning

```text
Goals
Diagnostic
Recommendation
Learning Path
Daily plan
```

## Release 0.4 — Study Companion

```text
PDF
Notes
Image
Flashcards
Spaced repetition
```

## Release 0.5 — Exam Preparation

```text
Timed practice
Mock exams
Exam analytics
Readiness tracking
```

## Release 0.6 — Chemistry Advantage

```text
Handwriting
Chemistry image extraction
Molecule visualization
Interactive experiments
```

## Release 1.0 — Learning Platform

```text
Parent
Teacher
Classroom
Gamification
Advanced analytics
```

---

# 15. Competitive Strategy

Do not define Learnova as:

> "A better Astra."

Instead:

> **Learnova is a Chemistry-first adaptive learning platform built around Knowledge Graph + Skill Mastery + AI Tutor + Recommendation.**

The strategic distinction is:

```text
Generic AI Learning
        ↓
AI generates content
        ↓
Student consumes content
```

versus:

```text
Learnova
        ↓
Understand curriculum
        ↓
Understand knowledge structure
        ↓
Understand student mastery
        ↓
Identify root gaps
        ↓
Choose next learning action
        ↓
Measure outcome
        ↓
Adapt
```

---

# 16. Final Priority Matrix

| Priority | Feature | Reason |
|---|---|---|
| P0 | Chemistry KG | Foundation |
| P0 | Skill model | Foundation |
| P0 | Mastery engine | Personalization |
| P0 | Diagnostic | Starting state |
| P0 | Knowledge-gap engine | Root-cause learning |
| P0 | Recommendation | Next action |
| P0 | Learning Path | End-to-end personalization |
| P0 | AI Tutor | User interaction |
| P0 | PDF/Image input | Real study materials |
| P1 | Flashcards | Retention |
| P1 | Spaced repetition | Retention |
| P1 | Daily plan | Habit / execution |
| P1 | Exam mode | Outcome |
| P1 | Mock exam | Exam readiness |
| P2 | Chemistry simulation | Differentiation |
| P2 | Handwriting | Input convenience |
| P2 | Voice | Accessibility |
| P2 | Parent | Ecosystem |
| P2 | Teacher | Ecosystem |
| P3 | Podcast | Optional |
| P3 | More subjects | Scale after Chemistry |
| P3 | Advanced analytics | Scale |

---

# 17. Bottom Line

Astra is useful as a **benchmark for product completeness**, but it should not dictate Learnova's architecture.

The next Learnova milestone should be:

> **From "AI Tutor + Practice + Skill Tracking" to "Adaptive Chemistry Learning System".**

The most important engineering sequence is:

```text
Chemistry Knowledge Graph
        ↓
Skill Mastery
        ↓
Knowledge Gap
        ↓
Recommendation
        ↓
Learning Path
        ↓
Practice / Tutor
        ↓
Assessment
        ↓
Mastery Update
```

Once this loop works reliably for Chemistry, the same architecture can be reused for Mathematics, Physics, Biology, English, Computer Science, and other subjects.

**Primary product goal:** prove that Learnova can understand both the **knowledge structure** and the **individual learner**, then continuously adapt what the learner should do next.
