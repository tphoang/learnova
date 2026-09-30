# Learnova — Project Summary

**Status:** Product / architecture baseline  
**Focus:** Chemistry-first AI Learning Platform  
**Long-term direction:** Multi-subject AI Learning Companion

---

## 1. Product Vision

> **Build an AI Learning Platform starting with Chemistry and expanding to other subjects.**

Learnova is designed as an **AI Learning Companion**, not simply an AI chatbot.

The platform should understand:

- what a student wants to learn;
- what the student already knows;
- which skills are weak;
- which concepts are prerequisites for other concepts;
- what the student should learn next;
- whether the student is ready for an exam or target.

Chemistry is the first subject because it provides a strong environment for building a structured Knowledge Graph, concept relationships, problem solving, visual input, and adaptive learning.

The architecture must remain **subject-agnostic** so that Mathematics, Physics, Biology, English, Computer Science, and other subjects can be added later without redesigning the core platform.

---

## 2. Problem

Traditional learning often has several problems:

1. Learning is not sufficiently personalized.
2. Students can consume content without actually mastering the underlying skills.
3. Related concepts are disconnected.
4. Students do not clearly know why they are getting questions wrong.
5. Practice is often not adapted to individual weaknesses.
6. Teachers and parents have limited visibility into detailed skill-level progress.
7. Students may spend time studying topics they already understand while missing prerequisite concepts.

Learnova addresses this through a continuous learning loop:

```text
Student
   ↓
Goal / Assessment
   ↓
Knowledge & Skills
   ↓
Practice
   ↓
Attempt
   ↓
Mastery
   ↓
Knowledge Gaps
   ↓
Recommendation
   ↓
Learning Path
   ↓
Next Activity
```

---

## 3. Core Solution

Learnova combines five major capabilities:

### 3.1 AI Tutor

An AI tutor provides:

- explanations;
- step-by-step problem solving;
- hints;
- examples;
- follow-up questions;
- misconception correction;
- contextual explanations based on the student's level.

The tutor should use structured learning data rather than behaving as an isolated general-purpose chatbot.

### 3.2 Knowledge Graph

The Knowledge Graph represents:

- subjects;
- topics;
- concepts;
- skills;
- prerequisites;
- related concepts;
- learning content;
- questions;
- misconceptions.

Example:

```text
Mole Concept
     ↓ prerequisite
Mole Calculation
     ↓ prerequisite
Chemical Ratios
     ↓ prerequisite
Stoichiometry
     ↓
Limiting Reagent
```

The graph enables Learnova to understand **why** a student is struggling, not only that they answered a question incorrectly.

### 3.3 Skill Engine / Mastery

Every student has an evolving mastery estimate for individual skills.

Example:

```text
Atomic Structure       91%
Chemical Bonding       76%
Equation Balancing     68%
Mole Calculation       54%
Stoichiometry          38%
```

Mastery should be updated from learning evidence such as:

- correctness;
- question difficulty;
- repeated attempts;
- time;
- hints;
- confidence;
- recent performance;
- review performance.

### 3.4 Recommendation Engine

The recommendation engine decides what the student should do next.

It should consider:

- current mastery;
- prerequisite dependencies;
- knowledge gaps;
- learning goal;
- exam date;
- target grade;
- available study time;
- recent performance;
- review schedule.

The recommendation should be explainable:

> "Review Chemical Ratios first because it is a prerequisite for the Stoichiometry skills you are currently missing."

### 3.5 Learning Path

Learning Path turns recommendations into a sequence of activities.

```text
Goal
 ↓
Diagnostic Assessment
 ↓
Current Skill Map
 ↓
Identify Critical Gaps
 ↓
Prerequisite Analysis
 ↓
Prioritize Skills
 ↓
Generate Learning Path
 ↓
Daily Activities
 ↓
Practice
 ↓
Re-plan
```

---

## 4. Chemistry-First Strategy

Chemistry is the initial subject.

The first Knowledge Graph should cover a manageable subset of Chemistry rather than attempting to model the entire subject immediately.

The earlier implementation plan considered starting with a compact Chemistry curriculum and expanding toward approximately **300–500 skills** with prerequisite relationships.

Initial Chemistry areas can include:

- Atomic Structure
- Periodic Table
- Chemical Bonding
- Chemical Formulas
- Chemical Equations
- Equation Balancing
- Mole Concept
- Stoichiometry
- Solutions
- Acids and Bases
- Redox
- Thermochemistry
- Organic Chemistry
- Other curriculum-specific areas

The exact curriculum and skill count should be validated against the target education system before production.

---

## 5. MVP 2.0

The original MVP concept was:

```text
Chat
Practice
Skill Tracking
```

The stronger MVP 2.0 is:

### P0

1. Learning Goal
2. Diagnostic Assessment
3. Chemistry Knowledge Graph
4. Skill Mastery
5. Knowledge Gap Engine
6. Adaptive Recommendation
7. Learning Path
8. AI Tutor
9. PDF / image / notes input
10. AI-generated lessons and practice
11. MCQ / short-answer / reasoning questions

### Core user journey

```text
Student signs up
      ↓
Chooses Chemistry goal
      ↓
Diagnostic assessment
      ↓
Initial skill map
      ↓
Learning path
      ↓
AI lesson
      ↓
Practice
      ↓
Attempt
      ↓
Mastery update
      ↓
Knowledge-gap detection
      ↓
Next recommendation
```

---

## 6. Input Types

Learnova should eventually support multiple inputs.

### Initial

- Text
- Image
- PDF
- Study notes

### Later

- Handwritten notes
- Camera capture
- Voice
- Spoken answers

The input layer should be modular so that the AI learning engine does not depend on a single input method.

---

## 7. Practice Engine

Practice should support:

- Multiple choice
- Fill-in-the-blank
- Short answer
- Numerical calculation
- Step-by-step problems
- Reasoning questions
- AI-generated questions
- Difficulty levels
- Hints
- Explanations
- Error analysis

A question should be connected to one or more skills.

```text
Question
   ↓
Skill(s)
   ↓
Attempt
   ↓
Assessment Evidence
   ↓
Mastery Update
```

---

## 8. Assessment Engine

### Diagnostic Assessment

Used to estimate the student's initial skill state.

```text
Diagnostic
   ↓
Skill Evidence
   ↓
Initial Mastery
   ↓
Knowledge Gaps
```

### Continuous Assessment

Every meaningful learning interaction can produce evidence.

Possible evidence:

- Correct / incorrect
- Difficulty
- Number of attempts
- Time
- Hint usage
- Confidence
- Recent history

### Exam Assessment

Future modes:

- Practice exam
- Timed exam
- Mock exam
- Written exam
- Oral exam

---

## 9. Spaced Repetition

A future review system should schedule skills and concepts for retrieval practice.

Conceptual model:

```text
Learn
 ↓
Practice
 ↓
Mastery
 ↓
Review scheduled
 ↓
Recall
 ↓
Mastery updated
 ↓
Next review scheduled
```

Possible entity:

```text
skill_review_schedule
---------------------
user_id
skill_id
due_at
interval
ease
last_reviewed_at
next_review_at
```

---

## 10. Chemistry Interactive Learning

A major future opportunity is Chemistry-specific interactive learning.

Potential features:

### Molecule Viewer

- 3D molecules
- atoms
- bonds
- geometry
- rotation / zoom

### Virtual Experiment

Example:

```text
NaOH + HCl
    ↓
Change concentration
    ↓
Observe pH
    ↓
Predict result
    ↓
Explain why
```

The goal is to connect conceptual knowledge with interactive experimentation.

---

## 11. Gamification

Gamification should reinforce learning behavior rather than simply reward activity volume.

Potential features:

- XP
- Streaks
- Daily goals
- Achievements
- Skill mastery milestones
- Learning challenges

Prefer rewards for meaningful learning outcomes, such as mastering a skill, completing a review, or improving from a previous level.

---

## 12. Parent and Teacher Layer

Future dashboards can expose useful learning information without exposing unnecessary AI-chat details.

### Parent Dashboard

Possible metrics:

- Overall mastery
- Subject mastery
- Weak skills
- Study time
- Weekly progress
- Upcoming exams
- Learning consistency

### Teacher Dashboard

Possible features:

- Classes
- Students
- Skill heatmap
- Assignment creation
- Quiz creation
- Student progress
- Common knowledge gaps

Example:

| Skill | Class Mastery |
|---|---:|
| Atomic Structure | 82% |
| Chemical Bonding | 68% |
| Equation Balancing | 54% |
| Stoichiometry | 41% |

---

## 13. Multi-Subject Architecture

Chemistry is the first subject, not the final scope.

Target future subjects include:

- Mathematics
- Physics
- Biology
- English
- Computer Science
- Other subjects

The database and services should therefore use generalized entities:

```text
Subject
  ↓
Curriculum
  ↓
Topic
  ↓
Lesson
  ↓
Skill
  ↓
Skill Relation
  ↓
Content / Question
```

Chemistry-specific functionality should live in subject modules rather than being hard-coded into the entire platform.

---

## 14. Technical Architecture

### Recommended initial stack

```text
Frontend
React Native
    │
    ▼
FastAPI Backend
    │
    ├── AI Tutor
    ├── Knowledge Graph Service
    ├── Skill / Mastery Engine
    ├── Recommendation Engine
    ├── Learning Path Engine
    ├── Practice / Assessment Engine
    └── RAG / Content Processing
    │
    ▼
PostgreSQL + pgvector
    │
    ├── Relational data
    ├── Skill graph relationships
    ├── Mastery
    ├── Questions
    ├── Attempts
    └── Embeddings
```

Optional future components:

- Redis for caching / queues
- Object storage for files
- Neo4j if graph scale or graph-specific workloads justify it

PostgreSQL should remain the initial system of record. Neo4j should not be introduced merely because the product contains a Knowledge Graph.

---

## 15. Database Design

The database was designed to remain flexible for future subjects.

Major entity groups:

### Users

- users
- profiles

### Curriculum

- subjects
- curricula
- topics
- lessons

### Knowledge Graph

- skills
- skill_relations

### Content

- content
- attachments
- embeddings / vector data

### Practice

- questions
- answers
- practice sessions
- attempts

### Learning

- user skill mastery
- recommendations
- learning paths
- study sessions
- review schedules

### AI Tutor

- conversations
- messages
- tutor context / RAG data

### Assessment

- exams
- exam questions
- exam attempts
- results

### Gamification

- achievements
- user achievements
- XP / progress data

The project already included a DBML direction and SQL schema direction, with generalized tables intended to support Chemistry first and later subjects.

---

## 16. AI Architecture

Learnova should separate AI generation from learning-state logic.

```text
LLM
 │
 ├── Explanation
 ├── Question Generation
 ├── Feedback
 └── Conversation
       │
       ▼
Structured Learning Engine
 │
 ├── Skill identification
 ├── Mastery update
 ├── Knowledge-gap detection
 ├── Recommendation
 └── Learning path
```

The LLM should **not be the source of truth for mastery**.

Mastery and recommendations should be based on structured application logic and stored evidence.

---

## 17. RAG

RAG can be used for:

- textbooks;
- curriculum material;
- teacher-provided content;
- uploaded notes;
- trusted learning resources.

A conceptual pipeline:

```text
PDF / Notes / Image
       ↓
Extract
       ↓
Chunk
       ↓
Embed
       ↓
Store
       ↓
Retrieve
       ↓
AI Tutor
```

RAG should be connected to curriculum and skill metadata whenever possible.

---

## 18. Recommendation Philosophy

Learnova should avoid a simplistic:

```text
Wrong answer → recommend same topic
```

Instead:

```text
Wrong Answer
     ↓
Identify Skill
     ↓
Check Difficulty
     ↓
Check Prerequisites
     ↓
Check Historical Mastery
     ↓
Identify Root Knowledge Gap
     ↓
Choose Next Activity
```

This is one of the core differentiators of Learnova.

---

## 19. Roadmap

### Phase 0 — Foundation

- Product requirements
- Information architecture
- Database
- API architecture
- Chemistry curriculum
- Initial Knowledge Graph
- Skill definitions

### Phase 1 — Core MVP

- Authentication
- Chemistry tutor
- Chat
- Practice
- Skill tracking
- Mastery
- Basic Knowledge Graph
- Basic recommendations

### Phase 2 — Adaptive Learning

- Diagnostic assessment
- Knowledge-gap engine
- Learning goals
- Learning paths
- Daily plans
- Adaptive recommendations

### Phase 3 — Rich Learning

- PDF / notes upload
- Image input
- Flashcards
- Spaced repetition
- Mock exams
- Exam mode

### Phase 4 — Advanced Chemistry

- Handwriting
- Voice
- Molecule visualization
- Interactive simulations
- Virtual experiments

### Phase 5 — Ecosystem

- Parent dashboard
- Teacher dashboard
- Classroom
- Advanced analytics
- Gamification

### Phase 6 — Multi-subject

- Mathematics
- Physics
- Biology
- English
- Computer Science
- Cross-subject Knowledge Graph

---

## 20. Product Principles

1. **Chemistry-first, architecture-first for all subjects.**
2. **AI Tutor is a component, not the whole product.**
3. **Knowledge Graph is central to personalization.**
4. **Mastery is skill-based, not just score-based.**
5. **Recommendations must be explainable.**
6. **Learning paths should adapt to the student.**
7. **PostgreSQL is the initial source of truth.**
8. **LLMs generate and explain; structured services maintain learning state.**
9. **The platform should understand prerequisites.**
10. **The system should optimize for learning outcomes, not chat volume.**

---

## 21. Core Differentiator

The central Learnova concept is:

> **Understand the learner → understand the knowledge → identify the gap → choose the next best learning activity → measure the result → adapt again.**

This creates a continuous adaptive learning loop rather than a conventional AI chatbot experience.

```text
          ┌──────────────────┐
          │      STUDENT     │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │  GOAL / ASSESS   │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │ KNOWLEDGE GRAPH  │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │ MASTERY / GAPS   │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │ RECOMMENDATION   │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │ LEARNING PATH    │
          └────────┬─────────┘
                   ↓
          ┌──────────────────┐
          │ PRACTICE / TUTOR │
          └────────┬─────────┘
                   ↓
              NEW EVIDENCE
                   │
                   └──────────→ back to MASTERY
```
