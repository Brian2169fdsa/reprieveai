# Goal Tracking System - Complete Architecture & Implementation Plan

**Date**: February 15, 2026
**Purpose**: Transform goal tracking from a to-do list into a structured reentry progress engine
**Platform**: Flutter Web + Firebase + AI Integration

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Firebase Data Model](#2-firebase-data-model)
3. [Starter Goal Library](#3-starter-goal-library)
4. [Component Architecture](#4-component-architecture)
5. [Daily Check-In System](#5-daily-check-in-system)
6. [AI Integration](#6-ai-integration)
7. [Sponsor Dashboard](#7-sponsor-dashboard)
8. [Social Sharing](#8-social-sharing)
9. [Giving System Integration](#9-giving-system-integration)
10. [Trust Score Integration](#10-trust-score-integration)
11. [Security & Privacy](#11-security--privacy)
12. [Implementation Roadmap](#12-implementation-roadmap)
13. [API Routes](#13-api-routes)
14. [UI/UX Specifications](#14-uiux-specifications)
15. [Testing Strategy](#15-testing-strategy)

---

## 1. System Overview

### 1.1 Core Purpose
The Goal System is the **behavioral backbone** of the NewFreedom platform. It bridges internal recovery (ISE) with external reintegration (New Freedom framework).

### 1.2 Three-Domain Model
```
┌─────────────────────────────────────────────────────────┐
│                    GOAL SYSTEM                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   RECOVERY   │  │   REENTRY    │  │   IDENTITY   │ │
│  │  (Internal)  │  │  (External)  │  │  (Future)    │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
│       │                   │                   │        │
│       ▼                   ▼                   ▼        │
│  - ISE Steps         - Housing           - Employment  │
│  - Meetings          - Legal Docs        - Education   │
│  - Sobriety          - Probation         - Career Dev  │
│  - Therapy           - Transportation    - Community   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 1.3 Key Principles
- **User Autonomy**: AI suggests, user controls
- **No Auto-Adjustment**: Goals never modified without user consent
- **Privacy First**: Granular visibility controls
- **Dignity-Centered**: Shareable wins, private struggles
- **Data-Driven**: Feeds AI, trust scoring, sponsor insights

---

## 2. Firebase Data Model

### 2.1 Collections Structure

```
firestore/
├── users/{uid}/
│   ├── profile (document)
│   ├── goals/{goalId}/ (collection)
│   │   ├── goal_data (document)
│   │   ├── milestones/{milestoneId}/ (subcollection)
│   │   ├── check_ins/{checkinId}/ (subcollection)
│   │   └── history/{historyId}/ (subcollection)
│   ├── daily_checkins/{dateKey}/ (collection)
│   ├── trust_score/{uid}/ (document)
│   └── sponsor_relationships/{sponsorshipId}/ (collection)
```

### 2.2 Goal Document Schema

```typescript
type Goal = {
  // Identity
  goalId: string;
  userId: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;

  // Core Data
  title: string;
  description?: string;
  category: GoalCategory;
  type: GoalType;

  // Scheduling
  targetDate?: Timestamp;
  startDate?: Timestamp;
  completedAt?: Timestamp;

  // Status
  status: 'active' | 'paused' | 'completed' | 'archived' | 'abandoned';

  // Progress
  difficulty: 1 | 2 | 3 | 4 | 5;
  definitionOfDone: string;
  currentStreak: number;
  longestStreak: number;
  totalCheckIns: number;
  successfulCheckIns: number;
  completionRate: number; // 0-100

  // Visibility
  visibility: {
    level: 'private' | 'sponsor_only' | 'public_milestone' | 'public_full';
    sponsorCanComment: boolean;
    shareWinsAutomatically: boolean;
  };

  // Integrations
  linkedNeedId?: string; // For giving system
  linkedISEStepId?: string; // For ISE integration
  linkedFundingRequests: string[];

  // AI Fields
  aiSummary?: string;
  riskScore?: number; // 0-100 (higher = more at-risk)
  lastAIAnalysis?: Timestamp;

  // Metadata
  tags: string[];
  customFields?: Record<string, any>;
  source: 'starter_template' | 'user_created' | 'sponsor_suggested';
  templateId?: string;
};

type GoalCategory =
  | 'recovery'
  | 'identity_legal'
  | 'employment'
  | 'housing'
  | 'health'
  | 'community'
  | 'personal_growth'
  | 'financial';

type GoalType =
  | 'habit' // Daily/weekly recurring
  | 'milestone' // One-time achievement
  | 'deadline' // Time-bound goal
  | 'financial' // Savings/payment goal
  | 'counter'; // Track number (days sober, etc.)
```

### 2.3 Milestone Document Schema

```typescript
type Milestone = {
  milestoneId: string;
  goalId: string;
  userId: string;

  title: string;
  description?: string;
  order: number; // Sequence in goal

  status: 'pending' | 'in_progress' | 'completed' | 'skipped';
  completedAt?: Timestamp;

  definition: string;
  evidence?: {
    type: 'photo' | 'document' | 'text';
    url?: string;
    text?: string;
  };

  shareOnCompletion: boolean;
  celebrationShared: boolean;

  createdAt: Timestamp;
  updatedAt: Timestamp;
};
```

### 2.4 Check-In Document Schema

```typescript
type CheckIn = {
  checkinId: string;
  goalId: string;
  userId: string;
  dateKey: string; // YYYY-MM-DD

  // User Input
  status: 'completed' | 'partial' | 'not_completed' | 'skipped';
  notes?: string;
  mood?: 'great' | 'good' | 'okay' | 'struggling' | 'crisis';
  obstacles?: string[];
  hoursSpent?: number;

  // AI Response
  aiResponse?: {
    encouragement: string;
    nextStep: string;
    reflection: string;
    concernFlag?: boolean;
  };

  // Metadata
  createdAt: Timestamp;
  submittedVia: 'daily_prompt' | 'manual' | 'sponsor_reminder';

  // Safety Flags
  crisisDetected: boolean;
  sponsorAlerted: boolean;
  resourcesSurfaced: boolean;
};
```

### 2.5 Daily Check-In Summary

```typescript
type DailyCheckinSummary = {
  userId: string;
  dateKey: string; // YYYY-MM-DD

  // Goals Checked
  totalActiveGoals: number;
  goalsCheckedIn: number;
  goalsCompleted: number;
  goalsPartial: number;
  goalsNotCompleted: number;
  goalsSkipped: number;

  // User State
  overallMood?: string;
  overallNotes?: string;

  // AI Analysis
  aiDailySummary?: string;
  concernsDetected: string[];
  strengthsIdentified: string[];
  suggestedActions: string[];

  // Timestamps
  createdAt: Timestamp;
  completedAt?: Timestamp;
};
```

### 2.6 Firestore Indexes Required

```json
{
  "indexes": [
    {
      "collectionGroup": "goals",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "goals",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "category", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "check_ins",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "goalId", "order": "ASCENDING" },
        { "fieldPath": "dateKey", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "daily_checkins",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "dateKey", "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## 3. Starter Goal Library

### 3.1 Template Structure

```typescript
type GoalTemplate = {
  templateId: string;
  category: GoalCategory;
  title: string;
  description: string;
  type: GoalType;
  difficulty: 1 | 2 | 3 | 4 | 5;
  definitionOfDone: string;
  suggestedMilestones?: string[];
  defaultDuration?: number; // days
  tags: string[];
  icon: string;
  popular: boolean;
};
```

### 3.2 Recovery Goals (Category A)

```typescript
const RECOVERY_GOALS: GoalTemplate[] = [
  {
    templateId: 'recovery_001',
    category: 'recovery',
    title: 'Attend 3 recovery meetings this week',
    description: 'Maintain consistent recovery meeting attendance',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Attend at least 3 in-person or virtual meetings per week',
    suggestedMilestones: [
      'Identify 3 nearby meetings',
      'Attend first meeting',
      'Get phone numbers from 2 people',
      'Complete 4 consecutive weeks'
    ],
    tags: ['recovery', 'meetings', 'community'],
    icon: 'people_outline',
    popular: true
  },
  {
    templateId: 'recovery_002',
    category: 'recovery',
    title: 'Check in with sponsor weekly',
    description: 'Regular accountability with recovery sponsor',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Contact sponsor at least once per week',
    tags: ['recovery', 'sponsor', 'accountability'],
    icon: 'phone',
    popular: true
  },
  {
    templateId: 'recovery_003',
    category: 'recovery',
    title: 'Complete Step 1',
    description: 'Work through Step 1 of recovery program',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Complete Step 1 written work and share with sponsor',
    suggestedMilestones: [
      'Watch ISE Step 1 video',
      'Complete written inventory',
      'Share with sponsor',
      'Present at meeting (optional)'
    ],
    tags: ['recovery', 'steps', 'ISE'],
    icon: 'check_circle',
    popular: true
  },
  {
    templateId: 'recovery_004',
    category: 'recovery',
    title: '30 days sober',
    description: 'Achieve 30 consecutive days of sobriety',
    type: 'counter',
    difficulty: 4,
    definitionOfDone: '30 consecutive days without substance use',
    suggestedMilestones: ['7 days', '14 days', '21 days', '30 days'],
    defaultDuration: 30,
    tags: ['recovery', 'sobriety', 'milestone'],
    icon: 'celebration',
    popular: true
  },
  {
    templateId: 'recovery_005',
    category: 'recovery',
    title: 'Daily reflection journal',
    description: 'Practice daily inventory and reflection',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Write at least 3 sentences daily about recovery',
    tags: ['recovery', 'reflection', 'habits'],
    icon: 'edit_note',
    popular: false
  },
  {
    templateId: 'recovery_006',
    category: 'recovery',
    title: 'Avoid identified triggers',
    description: 'Practice trigger awareness and avoidance',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Identify 3 triggers and create avoidance plan',
    suggestedMilestones: [
      'List top 3 triggers',
      'Create avoidance strategies',
      '7 days trigger-free',
      '30 days trigger-free'
    ],
    tags: ['recovery', 'triggers', 'awareness'],
    icon: 'shield',
    popular: false
  },
  {
    templateId: 'recovery_007',
    category: 'recovery',
    title: 'Practice mindfulness 10 minutes daily',
    description: 'Build daily meditation or mindfulness practice',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: '10 minutes of mindfulness or meditation daily',
    tags: ['recovery', 'mindfulness', 'mental_health'],
    icon: 'self_improvement',
    popular: false
  },
  {
    templateId: 'recovery_008',
    category: 'recovery',
    title: 'Create amends list',
    description: 'Prepare for making amends (Steps 8-9)',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Written list of people to make amends to',
    suggestedMilestones: [
      'Complete list',
      'Discuss with sponsor',
      'Make first amend',
      'Complete 3 amends'
    ],
    tags: ['recovery', 'amends', 'steps'],
    icon: 'handshake',
    popular: false
  }
];
```

### 3.3 Identity & Legal Goals (Category B)

```typescript
const IDENTITY_LEGAL_GOALS: GoalTemplate[] = [
  {
    templateId: 'legal_001',
    category: 'identity_legal',
    title: 'Obtain state ID',
    description: 'Get valid state identification card',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Possess valid state ID or driver\'s license',
    suggestedMilestones: [
      'Gather required documents',
      'Complete application',
      'Visit DMV',
      'Receive ID'
    ],
    defaultDuration: 30,
    tags: ['legal', 'identity', 'documents'],
    icon: 'badge',
    popular: true
  },
  {
    templateId: 'legal_002',
    category: 'identity_legal',
    title: 'Apply for birth certificate',
    description: 'Obtain official birth certificate',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Receive official birth certificate',
    suggestedMilestones: [
      'Identify issuing agency',
      'Complete application',
      'Submit payment',
      'Receive certificate'
    ],
    defaultDuration: 45,
    tags: ['legal', 'documents', 'identity'],
    icon: 'article',
    popular: true
  },
  {
    templateId: 'legal_003',
    category: 'identity_legal',
    title: 'Reinstate driver\'s license',
    description: 'Restore valid driver\'s license',
    type: 'milestone',
    difficulty: 4,
    definitionOfDone: 'Valid, active driver\'s license',
    suggestedMilestones: [
      'Check reinstatement requirements',
      'Pay outstanding fees',
      'Complete required courses',
      'Pass tests if needed',
      'Receive license'
    ],
    defaultDuration: 90,
    tags: ['legal', 'transportation', 'license'],
    icon: 'directions_car',
    popular: false
  },
  {
    templateId: 'legal_004',
    category: 'identity_legal',
    title: 'Resolve outstanding warrants',
    description: 'Clear any outstanding legal warrants',
    type: 'milestone',
    difficulty: 5,
    definitionOfDone: 'All warrants cleared or resolved',
    suggestedMilestones: [
      'Check warrant status',
      'Consult with legal aid',
      'Appear in court',
      'Complete resolution'
    ],
    tags: ['legal', 'court', 'resolution'],
    icon: 'gavel',
    popular: false
  },
  {
    templateId: 'legal_005',
    category: 'identity_legal',
    title: 'Meet with probation officer',
    description: 'Maintain probation compliance',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Attend all scheduled probation meetings',
    tags: ['legal', 'probation', 'compliance'],
    icon: 'event',
    popular: false
  },
  {
    templateId: 'legal_006',
    category: 'identity_legal',
    title: 'Pay court fines',
    description: 'Complete court-ordered financial obligations',
    type: 'financial',
    difficulty: 4,
    definitionOfDone: 'All court fines paid in full or on payment plan',
    suggestedMilestones: [
      'Determine total owed',
      'Set up payment plan',
      '25% paid',
      '50% paid',
      '100% paid'
    ],
    tags: ['legal', 'financial', 'court'],
    icon: 'payment',
    popular: false
  },
  {
    templateId: 'legal_007',
    category: 'identity_legal',
    title: 'Update legal address',
    description: 'Register current address with authorities',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Legal address updated with all required agencies',
    suggestedMilestones: [
      'Update with probation',
      'Update with DMV',
      'Update with court',
      'Update voter registration'
    ],
    tags: ['legal', 'administrative', 'compliance'],
    icon: 'home',
    popular: false
  },
  {
    templateId: 'legal_008',
    category: 'identity_legal',
    title: 'Obtain Social Security card',
    description: 'Get replacement Social Security card',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Possess valid Social Security card',
    suggestedMilestones: [
      'Gather documents',
      'Complete application',
      'Submit application',
      'Receive card'
    ],
    defaultDuration: 30,
    tags: ['legal', 'identity', 'documents'],
    icon: 'card_membership',
    popular: true
  }
];
```

### 3.4 Employment Goals (Category C)

```typescript
const EMPLOYMENT_GOALS: GoalTemplate[] = [
  {
    templateId: 'employ_001',
    category: 'employment',
    title: 'Build resume',
    description: 'Create professional resume',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Complete, proofread resume ready to send',
    suggestedMilestones: [
      'List work history',
      'List skills',
      'Get resume reviewed',
      'Finalize resume'
    ],
    defaultDuration: 7,
    tags: ['employment', 'resume', 'job_search'],
    icon: 'description',
    popular: true
  },
  {
    templateId: 'employ_002',
    category: 'employment',
    title: 'Apply to 5 jobs this week',
    description: 'Submit job applications',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Submit at least 5 job applications per week',
    tags: ['employment', 'job_search', 'applications'],
    icon: 'work',
    popular: true
  },
  {
    templateId: 'employ_003',
    category: 'employment',
    title: 'Attend job interview',
    description: 'Complete job interview',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Attend at least one job interview',
    suggestedMilestones: [
      'Schedule interview',
      'Prepare answers',
      'Attend interview',
      'Send thank-you note'
    ],
    tags: ['employment', 'interview', 'job_search'],
    icon: 'record_voice_over',
    popular: false
  },
  {
    templateId: 'employ_004',
    category: 'employment',
    title: 'Secure part-time employment',
    description: 'Get hired for part-time job',
    type: 'milestone',
    difficulty: 4,
    definitionOfDone: 'Receive and accept job offer for part-time position',
    suggestedMilestones: [
      'Get first interview',
      'Complete second interview',
      'Receive offer',
      'Complete first week'
    ],
    defaultDuration: 60,
    tags: ['employment', 'job_offer', 'income'],
    icon: 'check_circle',
    popular: true
  },
  {
    templateId: 'employ_005',
    category: 'employment',
    title: 'Secure full-time employment',
    description: 'Get hired for full-time job',
    type: 'milestone',
    difficulty: 5,
    definitionOfDone: 'Receive and accept job offer for full-time position',
    defaultDuration: 90,
    tags: ['employment', 'job_offer', 'career'],
    icon: 'business_center',
    popular: true
  },
  {
    templateId: 'employ_006',
    category: 'employment',
    title: 'Enroll in job training program',
    description: 'Join vocational or skills training',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Enrolled and attending job training program',
    suggestedMilestones: [
      'Research programs',
      'Apply to program',
      'Complete enrollment',
      'Attend first week'
    ],
    tags: ['employment', 'training', 'education'],
    icon: 'school',
    popular: false
  },
  {
    templateId: 'employ_007',
    category: 'employment',
    title: 'Open bank account',
    description: 'Establish banking relationship',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Open checking or savings account',
    suggestedMilestones: [
      'Choose bank',
      'Gather documents',
      'Open account',
      'Set up direct deposit'
    ],
    tags: ['financial', 'banking', 'employment'],
    icon: 'account_balance',
    popular: true
  },
  {
    templateId: 'employ_008',
    category: 'employment',
    title: 'Create monthly budget',
    description: 'Develop personal budget',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Written monthly budget tracking income and expenses',
    suggestedMilestones: [
      'List income sources',
      'List expenses',
      'Create budget',
      'Track for 30 days'
    ],
    tags: ['financial', 'budgeting', 'planning'],
    icon: 'calculate',
    popular: false
  },
  {
    templateId: 'employ_009',
    category: 'employment',
    title: 'Save $100 emergency fund',
    description: 'Build initial emergency savings',
    type: 'financial',
    difficulty: 3,
    definitionOfDone: '$100 saved in dedicated emergency fund',
    suggestedMilestones: ['$25', '$50', '$75', '$100'],
    tags: ['financial', 'savings', 'emergency'],
    icon: 'savings',
    popular: true
  }
];
```

### 3.5 Housing Goals (Category D)

```typescript
const HOUSING_GOALS: GoalTemplate[] = [
  {
    templateId: 'housing_001',
    category: 'housing',
    title: 'Apply for sober living',
    description: 'Submit application for sober living facility',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Application submitted to sober living facility',
    suggestedMilestones: [
      'Research facilities',
      'Tour facility',
      'Submit application',
      'Interview completed',
      'Acceptance received'
    ],
    tags: ['housing', 'recovery', 'sober_living'],
    icon: 'home',
    popular: true
  },
  {
    templateId: 'housing_002',
    category: 'housing',
    title: 'Apply for rental housing',
    description: 'Submit rental application',
    type: 'milestone',
    difficulty: 4,
    definitionOfDone: 'Rental application submitted',
    suggestedMilestones: [
      'Search listings',
      'View properties',
      'Submit application',
      'Approval received',
      'Lease signed'
    ],
    tags: ['housing', 'rental', 'permanent'],
    icon: 'apartment',
    popular: false
  },
  {
    templateId: 'housing_003',
    category: 'housing',
    title: 'Maintain 30 days stable housing',
    description: 'Sustain housing stability',
    type: 'counter',
    difficulty: 3,
    definitionOfDone: '30 consecutive days in stable housing',
    suggestedMilestones: ['7 days', '14 days', '21 days', '30 days'],
    defaultDuration: 30,
    tags: ['housing', 'stability', 'milestone'],
    icon: 'check_circle',
    popular: false
  },
  {
    templateId: 'housing_004',
    category: 'housing',
    title: 'Save for housing deposit',
    description: 'Save money for rental deposit',
    type: 'financial',
    difficulty: 4,
    definitionOfDone: 'Save full deposit amount (e.g., $500-$1000)',
    suggestedMilestones: ['25%', '50%', '75%', '100%'],
    tags: ['housing', 'financial', 'savings'],
    icon: 'savings',
    popular: true
  },
  {
    templateId: 'housing_005',
    category: 'housing',
    title: 'Meet with housing counselor',
    description: 'Consult with housing specialist',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Meet with housing counselor at least once',
    suggestedMilestones: [
      'Schedule appointment',
      'Attend meeting',
      'Create housing plan',
      'Follow-up meeting'
    ],
    tags: ['housing', 'counseling', 'support'],
    icon: 'support_agent',
    popular: false
  }
];
```

### 3.6 Health Goals (Category E)

```typescript
const HEALTH_GOALS: GoalTemplate[] = [
  {
    templateId: 'health_001',
    category: 'health',
    title: 'Schedule medical check-up',
    description: 'Book and attend medical appointment',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Complete medical check-up appointment',
    suggestedMilestones: [
      'Find clinic/doctor',
      'Schedule appointment',
      'Attend appointment',
      'Follow-up if needed'
    ],
    tags: ['health', 'medical', 'preventive'],
    icon: 'local_hospital',
    popular: false
  },
  {
    templateId: 'health_002',
    category: 'health',
    title: 'Schedule therapy appointment',
    description: 'Book mental health appointment',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Schedule first therapy session',
    suggestedMilestones: [
      'Find therapist',
      'Schedule intake',
      'Attend first session',
      'Schedule regular sessions'
    ],
    tags: ['health', 'mental_health', 'therapy'],
    icon: 'psychology',
    popular: true
  },
  {
    templateId: 'health_003',
    category: 'health',
    title: 'Attend therapy weekly',
    description: 'Maintain weekly therapy sessions',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Attend therapy at least once per week',
    tags: ['health', 'mental_health', 'therapy'],
    icon: 'event_repeat',
    popular: true
  },
  {
    templateId: 'health_004',
    category: 'health',
    title: 'Begin medication compliance',
    description: 'Take prescribed medications as directed',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Take medications as prescribed daily',
    tags: ['health', 'medication', 'compliance'],
    icon: 'medication',
    popular: false
  },
  {
    templateId: 'health_005',
    category: 'health',
    title: 'Establish sleep routine',
    description: 'Create consistent sleep schedule',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Sleep and wake at consistent times for 7 consecutive days',
    suggestedMilestones: [
      'Set sleep schedule',
      '3 days consistent',
      '7 days consistent',
      '14 days consistent'
    ],
    tags: ['health', 'sleep', 'habits'],
    icon: 'bedtime',
    popular: false
  }
];
```

### 3.7 Community Goals (Category F)

```typescript
const COMMUNITY_GOALS: GoalTemplate[] = [
  {
    templateId: 'community_001',
    category: 'community',
    title: 'Help someone in recovery',
    description: 'Provide support to another person in recovery',
    type: 'milestone',
    difficulty: 2,
    definitionOfDone: 'Offer meaningful help or support to someone in recovery',
    tags: ['community', 'service', 'recovery'],
    icon: 'volunteer_activism',
    popular: false
  },
  {
    templateId: 'community_002',
    category: 'community',
    title: 'Attend community event',
    description: 'Participate in local community event',
    type: 'milestone',
    difficulty: 1,
    definitionOfDone: 'Attend at least one community event',
    tags: ['community', 'engagement', 'social'],
    icon: 'groups',
    popular: false
  },
  {
    templateId: 'community_003',
    category: 'community',
    title: 'Volunteer once this month',
    description: 'Give time to volunteer organization',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Complete at least one volunteer shift per month',
    tags: ['community', 'volunteer', 'service'],
    icon: 'handshake',
    popular: false
  },
  {
    templateId: 'community_004',
    category: 'community',
    title: 'Rebuild family relationship',
    description: 'Reconnect with family member',
    type: 'milestone',
    difficulty: 4,
    definitionOfDone: 'Make positive contact with family member',
    suggestedMilestones: [
      'Identify person to reconnect with',
      'Discuss with sponsor',
      'Initiate contact',
      'Have meaningful conversation',
      'Establish regular contact'
    ],
    tags: ['community', 'family', 'relationships'],
    icon: 'family_restroom',
    popular: false
  },
  {
    templateId: 'community_005',
    category: 'community',
    title: 'Make amends to specific person',
    description: 'Complete amends as part of recovery',
    type: 'milestone',
    difficulty: 5,
    definitionOfDone: 'Make amends to identified person',
    suggestedMilestones: [
      'Discuss with sponsor',
      'Prepare what to say',
      'Initiate amends',
      'Complete amends process'
    ],
    tags: ['community', 'amends', 'recovery'],
    icon: 'handshake',
    popular: false
  }
];
```

### 3.8 Personal Growth Goals (Category G)

```typescript
const PERSONAL_GROWTH_GOALS: GoalTemplate[] = [
  {
    templateId: 'growth_001',
    category: 'personal_growth',
    title: 'Wake up at consistent time',
    description: 'Establish morning routine',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Wake at same time (±30 min) for 7 consecutive days',
    suggestedMilestones: ['3 days', '7 days', '14 days', '30 days'],
    tags: ['habits', 'routine', 'discipline'],
    icon: 'alarm',
    popular: false
  },
  {
    templateId: 'growth_002',
    category: 'personal_growth',
    title: 'Read 10 pages daily',
    description: 'Build daily reading habit',
    type: 'habit',
    difficulty: 2,
    definitionOfDone: 'Read at least 10 pages every day',
    tags: ['habits', 'reading', 'education'],
    icon: 'menu_book',
    popular: false
  },
  {
    templateId: 'growth_003',
    category: 'personal_growth',
    title: 'Exercise 3x per week',
    description: 'Build regular exercise routine',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Complete physical exercise at least 3 times per week',
    tags: ['health', 'exercise', 'habits'],
    icon: 'fitness_center',
    popular: false
  },
  {
    templateId: 'growth_004',
    category: 'personal_growth',
    title: 'Limit social media usage',
    description: 'Reduce screen time',
    type: 'habit',
    difficulty: 3,
    definitionOfDone: 'Limit social media to 30 minutes per day',
    suggestedMilestones: [
      'Track current usage',
      'Reduce by 25%',
      'Reduce by 50%',
      'At target usage'
    ],
    tags: ['habits', 'digital_wellness', 'discipline'],
    icon: 'phone_android',
    popular: false
  },
  {
    templateId: 'growth_005',
    category: 'personal_growth',
    title: 'Build 90-day life plan',
    description: 'Create structured life plan',
    type: 'milestone',
    difficulty: 3,
    definitionOfDone: 'Written 90-day plan with specific goals',
    suggestedMilestones: [
      'Reflect on values',
      'Set 3-month goals',
      'Create action steps',
      'Share with sponsor'
    ],
    tags: ['planning', 'goals', 'vision'],
    icon: 'edit_calendar',
    popular: false
  }
];
```

### 3.9 Complete Starter Library Export

```typescript
export const STARTER_GOAL_LIBRARY: GoalTemplate[] = [
  ...RECOVERY_GOALS,
  ...IDENTITY_LEGAL_GOALS,
  ...EMPLOYMENT_GOALS,
  ...HOUSING_GOALS,
  ...HEALTH_GOALS,
  ...COMMUNITY_GOALS,
  ...PERSONAL_GROWTH_GOALS
];

export const GOAL_CATEGORIES: Record<GoalCategory, { label: string; icon: string; description: string }> = {
  recovery: {
    label: 'Recovery',
    icon: 'favorite',
    description: 'Sobriety, meetings, steps, and internal transformation'
  },
  identity_legal: {
    label: 'Identity & Legal',
    icon: 'badge',
    description: 'IDs, documents, legal compliance, and administrative tasks'
  },
  employment: {
    label: 'Employment & Income',
    icon: 'work',
    description: 'Job search, employment, financial stability'
  },
  housing: {
    label: 'Housing',
    icon: 'home',
    description: 'Stable housing, sober living, rental applications'
  },
  health: {
    label: 'Health',
    icon: 'local_hospital',
    description: 'Medical care, therapy, medication, wellness'
  },
  community: {
    label: 'Community & Service',
    icon: 'groups',
    description: 'Relationships, volunteer work, family, amends'
  },
  personal_growth: {
    label: 'Personal Growth',
    icon: 'trending_up',
    description: 'Habits, discipline, learning, self-improvement'
  },
  financial: {
    label: 'Financial',
    icon: 'attach_money',
    description: 'Savings, budgeting, financial goals'
  }
};
```

---

## 4. Component Architecture

### 4.1 Component Tree

```
GoalsHome (Page)
├── GoalsHeader
│   ├── CategoryFilter
│   └── ViewToggle (Grid | List)
├── GoalsStats
│   ├── ActiveGoalsCount
│   ├── StreaksDisplay
│   └── CompletionRate
├── GoalsList
│   ├── GoalCard (multiple)
│   │   ├── GoalHeader
│   │   ├── GoalProgress
│   │   ├── GoalActions
│   │   └── GoalMilestones (collapsible)
│   └── EmptyState
└── FloatingActionButton
    └── AddGoalModal
        ├── TemplateSelector
        └── CustomGoalForm

DailyCheckinPage
├── CheckinHeader
│   └── Date + Streak
├── CheckinGoalsList
│   ├── CheckinGoalCard (multiple)
│   │   ├── GoalTitle
│   │   ├── StatusSelector
│   │   ├── NotesInput
│   │   ├── MoodSelector
│   │   └── ObstaclesInput
│   └── SubmitButton
└── AIResponsePanel
    ├── Encouragement
    ├── NextSteps
    └── Reflection

GoalDetailPage
├── GoalDetailHeader
│   ├── GoalTitle
│   ├── GoalCategory
│   ├── GoalActions (Edit | Delete | Archive)
│   └── VisibilitySettings
├── GoalProgressChart
│   ├── StreakVisualization
│   └── CompletionHistory
├── Milestones
│   └── MilestoneCard (multiple)
├── CheckinHistory
│   └── CheckinCard (multiple)
└── LinkedNeedsPanel (if funding linked)
```

### 4.2 Core Components (Flutter)

**File**: `lib/features/goals/goals_home_page.dart`
```dart
class GoalsHomePage extends StatefulWidget {
  const GoalsHomePage({super.key});

  @override
  State<GoalsHomePage> createState() => _GoalsHomePageState();
}

class _GoalsHomePageState extends State<GoalsHomePage> {
  GoalCategory? _selectedCategory;
  List<Goal> _goals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    // Load goals from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showCategoryFilter,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalModal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        GoalsStatsWidget(goals: _goals),
        Expanded(
          child: _goals.isEmpty
              ? const EmptyGoalsState()
              : GoalsListWidget(
                  goals: _filteredGoals,
                  onGoalTap: _navigateToGoalDetail,
                ),
        ),
      ],
    );
  }

  List<Goal> get _filteredGoals {
    if (_selectedCategory == null) return _goals;
    return _goals.where((g) => g.category == _selectedCategory).toList();
  }
}
```

**File**: `lib/features/goals/widgets/goal_card.dart`
```dart
class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(goal.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(goal.category),
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildStatusBadge(goal.status, statusColor),
                ],
              ),
              if (goal.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  goal.description!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (goal.currentStreak > 0) ...[
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${goal.currentStreak} day streak',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${goal.completionRate.toInt()}% complete',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              if (goal.targetDate != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _calculateProgress(goal),
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  'Due ${_formatDate(goal.targetDate!)}',
                  style: theme.textTheme.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(GoalCategory category) {
    // Return appropriate icon for category
  }

  double _calculateProgress(Goal goal) {
    // Calculate time-based or milestone-based progress
  }

  String _formatDate(DateTime date) {
    // Format date appropriately
  }
}
```

---

## 5. Daily Check-In System

### 5.1 Overview
The Daily Check-In is the **central engagement ritual** that connects users to their goals, provides AI insights, and generates trust score data.

### 5.2 Check-In Flow

```
┌─────────────────────────────────────────────────────────┐
│              DAILY CHECK-IN SEQUENCE                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. MORNING PROMPT (8am - 12pm)                         │
│     ├─ "How are you feeling today?"                     │
│     ├─ Mood selector (1-5 scale)                        │
│     └─ Optional text reflection                         │
│                                                          │
│  2. GOAL REVIEW (auto-displayed)                        │
│     ├─ Show today's active goals                        │
│     ├─ For each goal:                                   │
│     │   ├─ "Did you work on this today?"                │
│     │   ├─ Yes / No / Partially                         │
│     │   ├─ If Yes: "What did you do?"                   │
│     │   └─ If No: "What got in the way?"                │
│     └─ Update streaks automatically                     │
│                                                          │
│  3. AI COACHING (optional)                              │
│     ├─ AI analyzes check-in data                        │
│     ├─ Provides encouragement or redirection            │
│     └─ Suggests adjustments (user must approve)         │
│                                                          │
│  4. EVENING REFLECTION (6pm - 11pm)                     │
│     ├─ "What went well today?"                          │
│     ├─ "What was challenging?"                          │
│     ├─ Gratitude prompt                                 │
│     └─ Tomorrow's intention                             │
│                                                          │
│  5. DATA CAPTURE                                        │
│     ├─ Save to daily_checkins/{dateKey}                 │
│     ├─ Update goal streaks                              │
│     ├─ Trigger trust score calculation                  │
│     └─ Feed AI context database                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 5.3 Daily Check-In Schema

```typescript
type DailyCheckin = {
  // Identity
  checkinId: string;
  userId: string;
  date: string; // YYYY-MM-DD
  createdAt: Timestamp;
  completedAt?: Timestamp;

  // Mood & Reflection
  morningMood?: {
    scale: 1 | 2 | 3 | 4 | 5;
    note?: string;
    timestamp: Timestamp;
  };

  eveningReflection?: {
    wentWell?: string;
    challenging?: string;
    gratitude?: string;
    tomorrowIntention?: string;
    timestamp: Timestamp;
  };

  // Goal Progress
  goalUpdates: Array<{
    goalId: string;
    status: 'completed' | 'partial' | 'skipped' | 'not_applicable';
    note?: string;
    timestamp: Timestamp;
  }>;

  // AI Interaction
  aiCoaching?: {
    prompt: string;
    response: string;
    userReaction?: 'helpful' | 'not_helpful' | 'ignored';
    timestamp: Timestamp;
  };

  // Metadata
  checkInDuration?: number; // seconds
  skippedSections?: Array<'morning' | 'goals' | 'evening'>;
  isComplete: boolean;
  streakCount: number; // consecutive days of check-ins
};
```

### 5.4 Check-In UI Component (Flutter)

```dart
// lib/features/goals/widgets/daily_checkin_widget.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyCheckinWidget extends StatefulWidget {
  const DailyCheckinWidget({
    super.key,
    required this.userId,
    required this.onComplete,
  });

  final String userId;
  final VoidCallback onComplete;

  @override
  State<DailyCheckinWidget> createState() => _DailyCheckinWidgetState();
}

class _DailyCheckinWidgetState extends State<DailyCheckinWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  int? _morningMood;
  String? _morningNote;
  final Map<String, GoalCheckInData> _goalProgress = {};
  String? _wentWell;
  String? _challenging;
  String? _gratitude;
  String? _tomorrowIntention;

  List<Goal> _activeGoals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveGoals();
  }

  Future<void> _loadActiveGoals() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('goals')
        .where('status', isEqualTo: 'active')
        .get();

    setState(() {
      _activeGoals = snapshot.docs
          .map((doc) => Goal.fromFirestore(doc))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In'),
        actions: [
          TextButton(
            onPressed: _skipCheckIn,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / 4,
          ),
          const SizedBox(height: 16),

          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => _buildDot(index)),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMorningMoodPage(),
                _buildGoalReviewPage(),
                _buildAiCoachingPage(),
                _buildEveningReflectionPage(),
              ],
            ),
          ),

          // Navigation
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: _previousPage,
                    child: const Text('Back'),
                  )
                else
                  const SizedBox.shrink(),

                ElevatedButton(
                  onPressed: _currentPage == 3 ? _submitCheckIn : _nextPage,
                  child: Text(_currentPage == 3 ? 'Complete' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorningMoodPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),

          // Mood scale
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final moodValue = index + 1;
              return GestureDetector(
                onTap: () => setState(() => _morningMood = moodValue),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _morningMood == moodValue
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Icon(
                        _getMoodIcon(moodValue),
                        size: 32,
                        color: _morningMood == moodValue
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getMoodLabel(moodValue),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _morningMood == moodValue
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // Optional note
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Anything on your mind? (optional)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _morningNote = value,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalReviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Goals Today',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          if (_activeGoals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No active goals. Create one to get started!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            ..._activeGoals.map((goal) => _buildGoalCheckInCard(goal)).toList(),
        ],
      ),
    );
  }

  Widget _buildGoalCheckInCard(Goal goal) {
    final checkInData = _goalProgress[goal.goalId] ?? GoalCheckInData();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(goal.category),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status selector
            Text(
              'Did you work on this today?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Yes'),
                  selected: checkInData.status == 'completed',
                  onSelected: (selected) {
                    setState(() {
                      _goalProgress[goal.goalId] = checkInData.copyWith(
                        status: 'completed',
                      );
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Partially'),
                  selected: checkInData.status == 'partial',
                  onSelected: (selected) {
                    setState(() {
                      _goalProgress[goal.goalId] = checkInData.copyWith(
                        status: 'partial',
                      );
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('No'),
                  selected: checkInData.status == 'skipped',
                  onSelected: (selected) {
                    setState(() {
                      _goalProgress[goal.goalId] = checkInData.copyWith(
                        status: 'skipped',
                      );
                    });
                  },
                ),
              ],
            ),

            // Conditional text field
            if (checkInData.status != null) ...[
              const SizedBox(height: 12),
              TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: checkInData.status == 'skipped'
                      ? 'What got in the way?'
                      : 'What did you do?',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _goalProgress[goal.goalId] = checkInData.copyWith(
                    note: value,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAiCoachingPage() {
    // TODO: Implement AI coaching integration
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'AI Coaching (Coming Soon)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Our AI will analyze your check-in and provide personalized insights.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEveningReflectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evening Reflection',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'What went well today?',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _wentWell = value,
          ),
          const SizedBox(height: 16),

          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'What was challenging?',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _challenging = value,
          ),
          const SizedBox(height: 16),

          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'What are you grateful for?',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _gratitude = value,
          ),
          const SizedBox(height: 16),

          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Tomorrow\'s intention',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _tomorrowIntention = value,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }

  IconData _getMoodIcon(int mood) {
    switch (mood) {
      case 1: return Icons.sentiment_very_dissatisfied;
      case 2: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_neutral;
      case 4: return Icons.sentiment_satisfied;
      case 5: return Icons.sentiment_very_satisfied;
      default: return Icons.sentiment_neutral;
    }
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1: return 'Struggling';
      case 2: return 'Difficult';
      case 3: return 'Okay';
      case 4: return 'Good';
      case 5: return 'Great';
      default: return '';
    }
  }

  IconData _getCategoryIcon(GoalCategory category) {
    // Implementation from previous section
    return Icons.flag;
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitCheckIn() async {
    // Save to Firestore
    final dateKey = DateTime.now().toIso8601String().split('T')[0];

    final checkinData = {
      'checkinId': FirebaseFirestore.instance.collection('temp').doc().id,
      'userId': widget.userId,
      'date': dateKey,
      'createdAt': FieldValue.serverTimestamp(),
      'morningMood': _morningMood != null ? {
        'scale': _morningMood,
        'note': _morningNote,
        'timestamp': FieldValue.serverTimestamp(),
      } : null,
      'eveningReflection': {
        'wentWell': _wentWell,
        'challenging': _challenging,
        'gratitude': _gratitude,
        'tomorrowIntention': _tomorrowIntention,
        'timestamp': FieldValue.serverTimestamp(),
      },
      'goalUpdates': _goalProgress.entries.map((entry) => {
        'goalId': entry.key,
        'status': entry.value.status,
        'note': entry.value.note,
        'timestamp': FieldValue.serverTimestamp(),
      }).toList(),
      'isComplete': true,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('daily_checkins')
        .doc(dateKey)
        .set(checkinData);

    // Update goal streaks
    await _updateGoalStreaks();

    // Trigger trust score update (Cloud Function)
    // This would be handled by Firestore triggers

    widget.onComplete();
  }

  Future<void> _updateGoalStreaks() async {
    final batch = FirebaseFirestore.instance.batch();

    for (final entry in _goalProgress.entries) {
      if (entry.value.status == 'completed' || entry.value.status == 'partial') {
        final goalRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('goals')
            .doc(entry.key);

        batch.update(goalRef, {
          'currentStreak': FieldValue.increment(1),
          'lastCheckinDate': DateTime.now().toIso8601String().split('T')[0],
        });
      }
    }

    await batch.commit();
  }

  void _skipCheckIn() {
    Navigator.of(context).pop();
  }
}

class GoalCheckInData {
  final String? status;
  final String? note;

  GoalCheckInData({this.status, this.note});

  GoalCheckInData copyWith({String? status, String? note}) {
    return GoalCheckInData(
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}
```

### 5.5 Check-In Reminders

```typescript
// Firebase Cloud Function
// functions/src/scheduled/daily-checkin-reminders.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const sendMorningCheckinReminder = functions.pubsub
  .schedule('0 8 * * *') // 8 AM daily
  .timeZone('America/New_York')
  .onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date().toISOString().split('T')[0];

    // Find users who haven't checked in today
    const usersSnapshot = await db.collection('users').get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const checkinDoc = await db
        .collection('users')
        .doc(userId)
        .collection('daily_checkins')
        .doc(today)
        .get();

      if (!checkinDoc.exists) {
        // Send push notification
        await sendPushNotification(userId, {
          title: 'Good morning! ☀️',
          body: 'Take a moment to check in and set your intentions for today.',
          data: {
            route: '/goals/checkin',
          },
        });
      }
    }
  });

export const sendEveningReflectionReminder = functions.pubsub
  .schedule('0 20 * * *') // 8 PM daily
  .timeZone('America/New_York')
  .onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date().toISOString().split('T')[0];

    const usersSnapshot = await db.collection('users').get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const checkinDoc = await db
        .collection('users')
        .doc(userId)
        .collection('daily_checkins')
        .doc(today)
        .get();

      const checkin = checkinDoc.data();
      if (checkinDoc.exists && !checkin?.eveningReflection) {
        await sendPushNotification(userId, {
          title: 'Evening reflection 🌙',
          body: 'Take a moment to reflect on your day.',
          data: {
            route: '/goals/checkin',
          },
        });
      }
    }
  });

async function sendPushNotification(userId: string, payload: any) {
  // Implementation using FCM
}
```

---

## 6. AI Integration

### 6.1 AI System Overview

```
┌──────────────────────────────────────────────────────────┐
│                   AI COACHING SYSTEM                     │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  INPUT SOURCES                                           │
│  ├─ Daily check-in data                                 │
│  ├─ Goal progress history                               │
│  ├─ ISE step completion                                 │
│  ├─ My Struggle posts/comments                          │
│  └─ Trust score trends                                  │
│                                                          │
│  AI FUNCTIONS                                            │
│  ├─ Daily Insights (encouragement, pattern recognition) │
│  ├─ Goal Suggestions (based on recovery phase)          │
│  ├─ Barrier Analysis (identify obstacles)               │
│  ├─ Milestone Recommendations (adaptive pacing)         │
│  └─ Crisis Detection (mood trends, skip patterns)       │
│                                                          │
│  OUTPUT CHANNELS                                         │
│  ├─ In-app coaching messages                            │
│  ├─ Goal adjustment suggestions (user approves)         │
│  ├─ Sponsor alerts (with permission)                    │
│  └─ Personalized content recommendations                │
│                                                          │
│  GUARDRAILS                                              │
│  ├─ Never auto-adjust goals                             │
│  ├─ Always suggest, never command                       │
│  ├─ Respect user privacy settings                       │
│  └─ Escalate to human support when needed               │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### 6.2 AI Context Schema

```typescript
type AIContext = {
  userId: string;
  generatedAt: Timestamp;

  // Aggregated Data
  recentCheckins: Array<{
    date: string;
    moodAverage: number;
    goalsCompleted: number;
    goalsTotal: number;
  }>;

  activeGoals: Array<{
    goalId: string;
    title: string;
    category: GoalCategory;
    streakDays: number;
    completionRate: number;
    lastUpdated: string;
  }>;

  patterns: {
    consistencyScore: number; // 0-100
    preferredCheckinTime?: 'morning' | 'afternoon' | 'evening';
    strongCategories: GoalCategory[];
    strugglingCategories: GoalCategory[];
    riskFactors: Array<{
      type: 'declining_mood' | 'missed_checkins' | 'goal_abandonment';
      severity: 'low' | 'medium' | 'high';
      context: string;
    }>;
  };

  recoveryPhase?: 'early' | 'stabilizing' | 'rebuilding' | 'thriving';
  daysInRecovery?: number;
};
```

### 6.3 AI Coaching Implementation

```typescript
// functions/src/ai/coaching-engine.ts

import { Configuration, OpenAIApi } from 'openai';
import * as admin from 'firebase-admin';

const openai = new OpenAIApi(new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
}));

export class CoachingEngine {
  private db = admin.firestore();

  async generateDailyInsight(userId: string): Promise<string> {
    const context = await this.buildAIContext(userId);

    const prompt = this.buildPrompt(context);

    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: this.getSystemPrompt(),
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.7,
      max_tokens: 300,
    });

    const insight = response.data.choices[0].message?.content || '';

    // Save for reference
    await this.db
      .collection('users')
      .doc(userId)
      .collection('ai_interactions')
      .add({
        type: 'daily_insight',
        prompt,
        response: insight,
        context,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    return insight;
  }

  async suggestNewGoal(
    userId: string,
    category?: GoalCategory
  ): Promise<GoalSuggestion[]> {
    const context = await this.buildAIContext(userId);

    const prompt = `
Based on this user's recovery journey, suggest 3 achievable goals.

User Context:
- Recovery phase: ${context.recoveryPhase}
- Days in recovery: ${context.daysInRecovery}
- Active goals: ${context.activeGoals.map(g => g.title).join(', ')}
- Strong areas: ${context.patterns.strongCategories.join(', ')}
- Areas needing support: ${context.patterns.strugglingCategories.join(', ')}

${category ? `Focus on category: ${category}` : ''}

Format response as JSON array with: title, description, category, suggestedMilestones.
`;

    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: this.getSystemPrompt(),
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.8,
      max_tokens: 800,
    });

    const suggestions = JSON.parse(
      response.data.choices[0].message?.content || '[]'
    );

    return suggestions;
  }

  async analyzeBarriers(goalId: string): Promise<BarrierAnalysis> {
    const goal = await this.db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc(goalId)
      .get();

    const checkins = await this.db
      .collection('users')
      .doc(userId)
      .collection('daily_checkins')
      .where('goalUpdates.goalId', '==', goalId)
      .orderBy('date', 'desc')
      .limit(30)
      .get();

    const skipReasons = checkins.docs
      .flatMap(doc => {
        const data = doc.data();
        return data.goalUpdates
          .filter(u => u.goalId === goalId && u.status === 'skipped')
          .map(u => u.note);
      })
      .filter(note => note);

    const prompt = `
Analyze barriers preventing progress on this goal:

Goal: ${goal.data()?.title}
Recent skip reasons:
${skipReasons.join('\n')}

Identify:
1. Common patterns
2. Root causes
3. Practical solutions
4. When to adjust vs. when to persist

Format as JSON: {patterns: [], causes: [], solutions: [], recommendation: string}
`;

    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: this.getSystemPrompt(),
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.7,
    });

    return JSON.parse(response.data.choices[0].message?.content || '{}');
  }

  async detectCrisis(userId: string): Promise<CrisisAlert | null> {
    const context = await this.buildAIContext(userId);

    // Check for red flags
    const redFlags = [];

    // Declining mood trend
    const moodTrend = context.recentCheckins.map(c => c.moodAverage);
    if (this.isDecl ining(moodTrend)) {
      redFlags.push({
        type: 'declining_mood',
        severity: 'high',
        data: moodTrend,
      });
    }

    // Missed check-ins
    const missedDays = this.calculateMissedDays(context.recentCheckins);
    if (missedDays >= 3) {
      redFlags.push({
        type: 'missed_checkins',
        severity: missedDays >= 7 ? 'high' : 'medium',
        data: missedDays,
      });
    }

    // Abandoned goals
    const abandonedGoals = context.activeGoals.filter(
      g => g.completionRate < 20 && g.streakDays === 0
    );
    if (abandonedGoals.length >= 2) {
      redFlags.push({
        type: 'goal_abandonment',
        severity: 'medium',
        data: abandonedGoals.map(g => g.title),
      });
    }

    if (redFlags.length === 0) return null;

    // Generate alert
    const prompt = `
User showing signs of struggle:
${redFlags.map(f => `- ${f.type}: ${JSON.stringify(f.data)}`).join('\n')}

Generate:
1. Assessment of urgency (low/medium/high/emergency)
2. Recommended intervention
3. Message to sponsor (if appropriate)
4. Self-help resources to offer

Format as JSON.
`;

    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: this.getSystemPrompt(),
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
    });

    const alert = JSON.parse(response.data.choices[0].message?.content || '{}');

    // Log alert
    await this.db
      .collection('users')
      .doc(userId)
      .collection('crisis_alerts')
      .add({
        ...alert,
        redFlags,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    return alert;
  }

  private async buildAIContext(userId: string): Promise<AIContext> {
    // Aggregate user data for AI
    const userDoc = await this.db.collection('users').doc(userId).get();
    const user = userDoc.data();

    // Get recent check-ins (last 14 days)
    const checkinsSnapshot = await this.db
      .collection('users')
      .doc(userId)
      .collection('daily_checkins')
      .orderBy('date', 'desc')
      .limit(14)
      .get();

    const recentCheckins = checkinsSnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        date: data.date,
        moodAverage: data.morningMood?.scale || 3,
        goalsCompleted: data.goalUpdates.filter(g => g.status === 'completed').length,
        goalsTotal: data.goalUpdates.length,
      };
    });

    // Get active goals
    const goalsSnapshot = await this.db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .where('status', '==', 'active')
      .get();

    const activeGoals = goalsSnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        goalId: doc.id,
        title: data.title,
        category: data.category,
        streakDays: data.currentStreak || 0,
        completionRate: data.completionRate || 0,
        lastUpdated: data.updatedAt?.toDate().toISOString() || '',
      };
    });

    // Calculate patterns
    const patterns = this.analyzePatterns(recentCheckins, activeGoals);

    return {
      userId,
      generatedAt: admin.firestore.Timestamp.now(),
      recentCheckins,
      activeGoals,
      patterns,
      recoveryPhase: user?.recoveryPhase,
      daysInRecovery: user?.daysInRecovery,
    };
  }

  private getSystemPrompt(): string {
    return `You are a compassionate recovery coach for the NewFreedom platform.

Your role:
- Provide encouragement and practical guidance
- Recognize progress, no matter how small
- Help identify barriers without judgment
- Suggest adjustments, never commands
- Respect user autonomy and dignity
- Use trauma-informed, strengths-based language

Tone:
- Warm and supportive
- Honest but hopeful
- Concrete and actionable
- Never preachy or condescending

Remember:
- Recovery is non-linear
- Small wins matter
- Setbacks are data, not failure
- User is the expert on their own journey`;
  }

  private buildPrompt(context: AIContext): string {
    const avgMood = context.recentCheckins.reduce(
      (sum, c) => sum + c.moodAverage, 0
    ) / context.recentCheckins.length;

    const completionRate = context.recentCheckins.reduce(
      (sum, c) => sum + (c.goalsCompleted / c.goalsTotal), 0
    ) / context.recentCheckins.length;

    return `
Generate a brief, encouraging daily insight for this user.

Recent Activity:
- Check-ins completed: ${context.recentCheckins.length}/14 days
- Average mood: ${avgMood.toFixed(1)}/5
- Goal completion rate: ${(completionRate * 100).toFixed(0)}%
- Active goals: ${context.activeGoals.length}
- Recovery phase: ${context.recoveryPhase}

Strong areas: ${context.patterns.strongCategories.join(', ')}
Areas needing support: ${context.patterns.strugglingCategories.join(', ')}

Risk factors: ${context.patterns.riskFactors.length > 0
  ? context.patterns.riskFactors.map(r => r.type).join(', ')
  : 'None identified'}

Generate a 2-3 sentence insight that:
1. Acknowledges their effort
2. Highlights a specific strength or pattern
3. Offers one actionable suggestion

Keep it personal, specific, and hopeful.
`;
  }

  private analyzePatterns(checkins: any[], goals: any[]): any {
    // Implementation of pattern analysis
    return {
      consistencyScore: 0,
      strongCategories: [],
      strugglingCategories: [],
      riskFactors: [],
    };
  }

  private isDecl ining(values: number[]): boolean {
    // Simple declining trend detection
    if (values.length < 3) return false;
    const recent = values.slice(0, 3);
    return recent.every((val, i) => i === 0 || val < recent[i - 1]);
  }

  private calculateMissedDays(checkins: any[]): number {
    const last14Days = Array.from({length: 14}, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - i);
      return d.toISOString().split('T')[0];
    });

    const checkinDates = new Set(checkins.map(c => c.date));
    return last14Days.filter(d => !checkinDates.has(d)).length;
  }
}

// Type definitions
type GoalSuggestion = {
  title: string;
  description: string;
  category: GoalCategory;
  suggestedMilestones: string[];
};

type BarrierAnalysis = {
  patterns: string[];
  causes: string[];
  solutions: string[];
  recommendation: string;
};

type CrisisAlert = {
  urgency: 'low' | 'medium' | 'high' | 'emergency';
  intervention: string;
  sponsorMessage?: string;
  resources: string[];
};
```

### 6.4 AI-Powered Goal Suggestions UI

```dart
// lib/features/goals/widgets/ai_suggestions_widget.dart
import 'package:flutter/material.dart';

class AiSuggestionsWidget extends StatefulWidget {
  const AiSuggestionsWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AiSuggestionsWidget> createState() => _AiSuggestionsWidgetState();
}

class _AiSuggestionsWidgetState extends State<AiSuggestionsWidget> {
  List<GoalSuggestion> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() => _isLoading = true);

    // Call Cloud Function
    final callable = FirebaseFunctions.instance.httpsCallable('getSuggestedGoals');
    final result = await callable.call({'userId': widget.userId});

    setState(() {
      _suggestions = (result.data as List)
          .map((s) => GoalSuggestion.fromJson(s))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'AI-Suggested Goals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _loadSuggestions,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._suggestions.map((suggestion) => _buildSuggestionCard(suggestion)).toList(),
      ],
    );
  }

  Widget _buildSuggestionCard(GoalSuggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    suggestion.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              suggestion.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (suggestion.suggestedMilestones.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Suggested milestones:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              ...suggestion.suggestedMilestones.take(3).map(
                (milestone) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          milestone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _dismissSuggestion(suggestion),
                  child: const Text('Not now'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _acceptSuggestion(suggestion),
                  child: const Text('Add Goal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptSuggestion(GoalSuggestion suggestion) {
    // Navigate to create goal page with pre-filled data
    Navigator.pushNamed(
      context,
      '/goals/create',
      arguments: suggestion,
    );
  }

  void _dismissSuggestion(GoalSuggestion suggestion) {
    setState(() {
      _suggestions.remove(suggestion);
    });
  }
}
```

---

## 7. Sponsor Dashboard

### 7.1 Sponsor Visibility Model

Users can grant sponsors varying levels of access to their goal progress:

```typescript
type SponsorVisibility = {
  sponsorshipId: string;
  sponsorId: string;
  sponsoredUserId: string;

  permissions: {
    viewGoals: 'all' | 'public_only' | 'none';
    viewCheckins: boolean;
    viewMoodTrends: boolean;
    viewMilestones: boolean;
    receiveAlerts: boolean;
    canComment: boolean;
  };

  alertPreferences: {
    missedCheckins: number; // days before alert
    decliningSyncScore: boolean;
    milestoneCompleted: boolean;
    crisisDetected: boolean;
  };

  createdAt: Timestamp;
  updatedAt: Timestamp;
};
```

### 7.2 Sponsor Dashboard Schema

```typescript
type SponsorDashboard = {
  sponsorId: string;

  sponsoredUsers: Array<{
    userId: string;
    displayName: string;
    profileImage?: string;
    daysInRecovery: number;

    summary: {
      activeGoals: number;
      completedGoals: number;
      currentStreak: number; // consecutive check-ins
      lastCheckinDate: string;
      trustScore: number;
      recentMoodTrend: 'improving' | 'stable' | 'declining';
    };

    alerts: Array<{
      type: 'missed_checkin' | 'crisis' | 'milestone';
      severity: 'low' | 'medium' | 'high';
      message: string;
      createdAt: Timestamp;
      acknowledged: boolean;
    }>;

    recentActivity: Array<{
      type: 'goal_created' | 'milestone_completed' | 'checkin_completed' | 'struggle_post';
      title: string;
      date: Timestamp;
    }>;
  }>;
};
```

### 7.3 Sponsor Dashboard UI

```dart
// lib/features/sponsor/sponsor_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SponsorDashboardPage extends StatelessWidget {
  const SponsorDashboardPage({
    super.key,
    required this.sponsorId,
  });

  final String sponsorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sponsees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sponsor_relationships')
            .where('sponsorId', isEqualTo: sponsorId)
            .where('status', isEqualTo: 'active')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sponsorships = snapshot.data!.docs;

          if (sponsorships.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active sponsees',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Users you sponsor will appear here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sponsorships.length,
            itemBuilder: (context, index) {
              return _buildSponsoreeCard(
                context,
                sponsorships[index].data() as Map<String, dynamic>,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSponsoreeCard(BuildContext context, Map<String, dynamic> sponsorship) {
    final sponsoredUserId = sponsorship['sponsoredUserId'] as String;

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadSponsoreeData(sponsoredUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final data = snapshot.data!;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/sponsor/sponsoree-detail',
                arguments: sponsoredUserId,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: data['profileImage'] != null
                            ? NetworkImage(data['profileImage'])
                            : null,
                        child: data['profileImage'] == null
                            ? Text(data['displayName'][0])
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['displayName'],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${data['daysInRecovery']} days in recovery',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (data['alerts'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${data['alerts']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.flag,
                          label: 'Active Goals',
                          value: '${data['activeGoals']}',
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.local_fire_department,
                          label: 'Streak',
                          value: '${data['currentStreak']} days',
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.trending_up,
                          label: 'Trust Score',
                          value: '${data['trustScore']}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Last check-in
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: _getCheckinStatusColor(data['daysSinceCheckin']),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getCheckinStatusText(data['daysSinceCheckin']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getCheckinStatusColor(data['daysSinceCheckin']),
                        ),
                      ),
                    ],
                  ),

                  // Mood trend
                  if (data['moodTrend'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getMoodTrendIcon(data['moodTrend']),
                          size: 16,
                          color: _getMoodTrendColor(data['moodTrend']),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mood: ${data['moodTrend']}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _loadSponsoreeData(String userId) async {
    final db = FirebaseFirestore.instance;

    // Load user profile
    final userDoc = await db.collection('users').doc(userId).get();
    final userData = userDoc.data()!;

    // Load active goals count
    final goalsSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .where('status', isEqualTo: 'active')
        .get();

    // Load recent check-in
    final checkinsSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('daily_checkins')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    final lastCheckinDate = checkinsSnapshot.docs.isNotEmpty
        ? checkinsSnapshot.docs.first.data()['date'] as String
        : null;

    final daysSinceCheckin = lastCheckinDate != null
        ? DateTime.now().difference(DateTime.parse(lastCheckinDate)).inDays
        : 999;

    // Load unacknowledged alerts
    final alertsSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('sponsor_alerts')
        .where('acknowledged', isEqualTo: false)
        .get();

    return {
      'displayName': userData['displayName'] ?? 'Unknown',
      'profileImage': userData['profileImage'],
      'daysInRecovery': userData['daysInRecovery'] ?? 0,
      'activeGoals': goalsSnapshot.docs.length,
      'currentStreak': userData['checkinStreak'] ?? 0,
      'trustScore': userData['trustScore'] ?? 0,
      'daysSinceCheckin': daysSinceCheckin,
      'moodTrend': userData['recentMoodTrend'],
      'alerts': alertsSnapshot.docs.length,
    };
  }

  Color _getCheckinStatusColor(int days) {
    if (days == 0) return Colors.green;
    if (days == 1) return Colors.orange;
    return Colors.red;
  }

  String _getCheckinStatusText(int days) {
    if (days == 0) return 'Checked in today';
    if (days == 1) return 'Last check-in yesterday';
    return 'Last check-in $days days ago';
  }

  IconData _getMoodTrendIcon(String trend) {
    switch (trend) {
      case 'improving': return Icons.trending_up;
      case 'stable': return Icons.trending_flat;
      case 'declining': return Icons.trending_down;
      default: return Icons.help_outline;
    }
  }

  Color _getMoodTrendColor(String trend) {
    switch (trend) {
      case 'improving': return Colors.green;
      case 'stable': return Colors.blue;
      case 'declining': return Colors.red;
      default: return Colors.grey;
    }
  }
}
```

### 7.4 Sponsoree Detail View

```dart
// lib/features/sponsor/sponsoree_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoreeDetailPage extends StatelessWidget {
  const SponsoreeDetailPage({
    super.key,
    required this.sponsoredUserId,
  });

  final String sponsoredUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(sponsoredUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: user['profileImage'] != null
                            ? NetworkImage(user['profileImage'])
                            : null,
                        child: user['profileImage'] == null
                            ? Text(
                                user['displayName'][0],
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user['displayName'],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user['daysInRecovery']} days in recovery',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                // Goals section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Goals',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildGoalsList(),
                    ],
                  ),
                ),

                // Check-in history
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-In History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildCheckinHistory(),
                    ],
                  ),
                ),

                // Milestones
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Milestones',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildMilestonesList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _sendEncouragementMessage(context),
        icon: const Icon(Icons.message),
        label: const Text('Send Message'),
      ),
    );
  }

  Widget _buildGoalsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(sponsoredUserId)
          .collection('goals')
          .where('status', isEqualTo: 'active')
          .where('visibility.level', whereIn: ['sponsor_only', 'public_milestone'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final goals = snapshot.data!.docs;

        if (goals.isEmpty) {
          return const Text('No visible goals');
        }

        return Column(
          children: goals.map((doc) {
            final goal = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${goal['completionRate']?.toInt() ?? 0}%'),
                ),
                title: Text(goal['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (goal['completionRate'] ?? 0) / 100,
                    ),
                    const SizedBox(height: 4),
                    Text('${goal['currentStreak'] ?? 0} day streak'),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  // Navigate to goal detail
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCheckinHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(sponsoredUserId)
          .collection('daily_checkins')
          .orderBy('date', descending: true)
          .limit(14)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final checkins = snapshot.data!.docs;

        return _buildCheckinCalendar(checkins);
      },
    );
  }

  Widget _buildCheckinCalendar(List<QueryDocumentSnapshot> checkins) {
    final last14Days = List.generate(14, (index) {
      final date = DateTime.now().subtract(Duration(days: 13 - index));
      return date.toIso8601String().split('T')[0];
    });

    final checkinDates = checkins.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['date'] as String;
    }).toSet();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: last14Days.map((date) {
        final hasCheckin = checkinDates.contains(date);
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: hasCheckin ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              DateTime.parse(date).day.toString(),
              style: TextStyle(
                color: hasCheckin ? Colors.white : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMilestonesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('milestones')
          .where('userId', isEqualTo: sponsoredUserId)
          .where('isCompleted', isEqualTo: true)
          .orderBy('completedAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final milestones = snapshot.data!.docs;

        if (milestones.isEmpty) {
          return const Text('No milestones completed yet');
        }

        return Column(
          children: milestones.map((doc) {
            final milestone = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 32,
                ),
                title: Text(milestone['title']),
                subtitle: Text(
                  'Completed ${_formatDate(milestone['completedAt'])}',
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'today';
    if (diff == 1) return 'yesterday';
    if (diff < 7) return '$diff days ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  void _sendEncouragementMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Encouragement'),
        content: TextField(
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Write a message of encouragement...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Send message logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
```

---

## 8. Social Sharing

### 8.1 Social Sharing Philosophy

Goals system integrates with My Struggle for **dignity-first sharing**:
- Users control what's shared
- Milestones are celebration-worthy
- Struggles stay private unless user chooses to share
- No leaderboards or comparisons

### 8.2 Shareable Content Types

```typescript
type ShareableContent = {
  type: 'milestone_completed' | 'goal_created' | 'streak_achieved' | 'reflection';
  visibility: 'private' | 'connections' | 'public';

  milestone?: {
    goalId: string;
    goalTitle: string;
    milestoneTitle: string;
    completedAt: Timestamp;
    celebrationNote?: string;
  };

  goal?: {
    goalId: string;
    title: string;
    category: GoalCategory;
    whyThis?: string; // User's personal motivation
  };

  streak?: {
    type: 'checkin' | 'goal';
    days: number;
    goalTitle?: string;
  };

  reflection?: {
    text: string;
    mood?: number;
    tags?: string[];
  };
};
```

### 8.3 Share to My Struggle Flow

```dart
// lib/features/goals/widgets/share_milestone_widget.dart
import 'package:flutter/material.dart';

class ShareMilestoneWidget extends StatefulWidget {
  const ShareMilestoneWidget({
    super.key,
    required this.milestone,
    required this.goalTitle,
  });

  final Milestone milestone;
  final String goalTitle;

  @override
  State<ShareMilestoneWidget> createState() => _ShareMilestoneWidgetState();
}

class _ShareMilestoneWidgetState extends State<ShareMilestoneWidget> {
  String _visibility = 'connections';
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.celebration,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Celebrate Your Win!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share this milestone with your community',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preview card
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'MILESTONE COMPLETED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.milestone.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Part of: ${widget.goalTitle}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Optional celebration note
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Add a note (optional)',
              hintText: 'What does this milestone mean to you?',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Visibility selector
          Text(
            'Who can see this?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),

          Column(
            children: [
              RadioListTile<String>(
                title: const Text('My connections'),
                subtitle: const Text('People you follow and sponsors'),
                value: 'connections',
                groupValue: _visibility,
                onChanged: (value) => setState(() => _visibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('Everyone'),
                subtitle: const Text('Public in My Struggle feed'),
                value: 'public',
                groupValue: _visibility,
                onChanged: (value) => setState(() => _visibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('Just me'),
                subtitle: const Text('Private - only in your profile'),
                value: 'private',
                groupValue: _visibility,
                onChanged: (value) => setState(() => _visibility = value!),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Skip'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _shareToMyStruggle,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareToMyStruggle() async {
    // Create post in My Struggle
    final post = {
      'type': 'milestone_completed',
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'visibility': _visibility,
      'content': {
        'goalTitle': widget.goalTitle,
        'milestoneTitle': widget.milestone.title,
        'note': _noteController.text,
      },
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('my_struggle_posts')
        .add(post);

    // Update milestone with share info
    await widget.milestone.reference.update({
      'shared': true,
      'sharedAt': FieldValue.serverTimestamp(),
      'visibility': _visibility,
    });

    // Award giving credits for sharing
    await _awardGivingCredits();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Milestone shared! You earned 10 credits.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _awardGivingCredits() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'givingCredits': FieldValue.increment(10),
    });

    // Log transaction
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('giving_transactions')
        .add({
      'type': 'earned',
      'amount': 10,
      'source': 'milestone_shared',
      'sourceId': widget.milestone.milestoneId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
```

### 8.4 My Struggle Feed Integration

```dart
// Example post card in My Struggle showing goal milestone
import 'package:flutter/material.dart';

class GoalMilestonePostCard extends StatelessWidget {
  const GoalMilestonePostCard({
    super.key,
    required this.post,
  });

  final MyStrugglePost post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.authorImage != null
                  ? NetworkImage(post.authorImage!)
                  : null,
              child: post.authorImage == null
                  ? Text(post.authorName[0])
                  : null,
            ),
            title: Text(post.authorName),
            subtitle: Text(_formatTimeAgo(post.createdAt)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Milestone badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade400,
                        Colors.orange.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MILESTONE ACHIEVED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.content['milestoneTitle'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.content['goalTitle'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (post.content['note'] != null && post.content['note'].isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    post.content['note'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),

          // Actions
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                label: Text('${post.likes}'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
                label: Text('${post.comments}'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Give'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
```

---

## 9. Giving System Integration

### 9.1 How Goals Earn Giving Credits

```typescript
type GivingEarnRules = {
  // Milestone-based earning
  milestone_completed: {
    credits: 10,
    bonus_if_first: 5,
    bonus_if_shared: 10,
  };

  // Streak-based earning
  checkin_streak: {
    7_days: 25,
    14_days: 50,
    30_days: 100,
    90_days: 250,
  };

  // Goal completion
  goal_completed: {
    credits: 50,
    bonus_if_under_30_days: 25,
  };

  // Social engagement
  milestone_shared: 10,
  received_encouragement: 5,
};
```

### 9.2 Giving from Goals

Users can give directly from milestone celebrations:

```dart
// lib/features/goals/widgets/give_from_milestone_widget.dart
import 'package:flutter/material.dart';

class GiveFromMilestoneButton extends StatelessWidget {
  const GiveFromMilestoneButton({
    super.key,
    required this.authorId,
    required this.postId,
  });

  final String authorId;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showGiveDialog(context),
      icon: const Icon(Icons.volunteer_activism),
      label: const Text('Give'),
    );
  }

  void _showGiveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GiveDialog(
        recipientId: authorId,
        sourceType: 'milestone_celebration',
        sourceId: postId,
      ),
    );
  }
}

class GiveDialog extends StatefulWidget {
  const GiveDialog({
    super.key,
    required this.recipientId,
    required this.sourceType,
    required this.sourceId,
  });

  final String recipientId;
  final String sourceType;
  final String sourceId;

  @override
  State<GiveDialog> createState() => _GiveDialogState();
}

class _GiveDialogState extends State<GiveDialog> {
  int _amount = 10;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.volunteer_activism, color: Colors.red),
          SizedBox(width: 8),
          Text('Give Credits'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Celebrate this milestone by giving credits',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Amount slider
          Text(
            '$_amount credits',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: _amount.toDouble(),
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: (value) => setState(() => _amount = value.toInt()),
          ),

          const SizedBox(height: 16),

          // Optional message
          TextField(
            controller: _messageController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Add a message (optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitGiving,
          child: const Text('Give'),
        ),
      ],
    );
  }

  Future<void> _submitGiving() async {
    final giverId = FirebaseAuth.instance.currentUser!.uid;

    // Check balance
    final giverDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(giverId)
        .get();

    final balance = giverDoc.data()?['givingCredits'] ?? 0;

    if (balance < _amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient credits')),
      );
      return;
    }

    // Create transaction
    final batch = FirebaseFirestore.instance.batch();

    // Deduct from giver
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(giverId),
      {'givingCredits': FieldValue.increment(-_amount)},
    );

    // Add to recipient
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(widget.recipientId),
      {'givingCredits': FieldValue.increment(_amount)},
    );

    // Log transaction
    final transactionRef = FirebaseFirestore.instance
        .collection('giving_transactions')
        .doc();

    batch.set(transactionRef, {
      'transactionId': transactionRef.id,
      'giverId': giverId,
      'recipientId': widget.recipientId,
      'amount': _amount,
      'message': _messageController.text,
      'sourceType': widget.sourceType,
      'sourceId': widget.sourceId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gave $_amount credits!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

### 9.3 Goal-Based Giving Notifications

```typescript
// Firebase Cloud Function
// functions/src/giving/goal-giving-notification.ts

export const onGivingReceived = functions.firestore
  .document('giving_transactions/{transactionId}')
  .onCreate(async (snap, context) => {
    const transaction = snap.data();

    if (transaction.sourceType === 'milestone_celebration') {
      // Send notification to recipient
      await sendPushNotification(transaction.recipientId, {
        title: '❤️ You received credits!',
        body: `Someone gave you ${transaction.amount} credits for your milestone achievement`,
        data: {
          route: '/giving/history',
          transactionId: snap.id,
        },
      });

      // Update recipient's recent activity
      await admin.firestore()
        .collection('users')
        .doc(transaction.recipientId)
        .collection('activity')
        .add({
          type: 'giving_received',
          amount: transaction.amount,
          giverId: transaction.giverId,
          sourceType: transaction.sourceType,
          sourceId: transaction.sourceId,
          message: transaction.message,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
  });
```

---

## 10. Trust Score Integration

### 10.1 How Goals Impact Trust Score

The Trust Score system uses goal data as a **key behavioral signal**:

```typescript
type TrustScoreFactors = {
  // Goal consistency (30% weight)
  goalConsistency: {
    activeGoalsCount: number;      // Having 1-5 active goals
    completionRate: number;         // % of goals completed
    abandonmentRate: number;        // % of goals abandoned
    weight: 0.30,
  };

  // Check-in consistency (25% weight)
  checkinConsistency: {
    streak: number;                 // Consecutive days
    missedDays: number;             // Last 30 days
    completionQuality: number;      // Full vs. partial check-ins
    weight: 0.25,
  };

  // Progress momentum (20% weight)
  progressMomentum: {
    milestonesCompleted: number;    // Last 30 days
    avgDaysToMilestone: number;     // Speed of progress
    streakMaintenance: boolean;     // No broken streaks
    weight: 0.20,
  };

  // Social engagement (15% weight)
  socialEngagement: {
    milestonesShared: number;       // Transparency
    encouragementGiven: number;     // Community support
    sponsorInteraction: boolean;    // Engaging with sponsor
    weight: 0.15,
  };

  // AI coaching adoption (10% weight)
  aiAdoption: {
    suggestionsImplemented: number;
    barriersAddressed: number;
    adjustmentsMade: number;
    weight: 0.10,
  };
};
```

### 10.2 Trust Score Calculation

```typescript
// functions/src/trust-score/calculate-goal-score.ts

import * as admin from 'firebase-admin';

export async function calculateGoalTrustScore(
  userId: string
): Promise<number> {
  const db = admin.firestore();

  // Fetch goal data
  const goalsSnapshot = await db
    .collection('users')
    .doc(userId)
    .collection('goals')
    .get();

  const goals = goalsSnapshot.docs.map(doc => doc.data());

  // 1. Goal Consistency (30%)
  const activeGoals = goals.filter(g => g.status === 'active').length;
  const completedGoals = goals.filter(g => g.status === 'completed').length;
  const abandonedGoals = goals.filter(g => g.status === 'archived' && g.completionRate < 50).length;
  const totalGoals = goals.length;

  const idealActiveGoals = Math.min(activeGoals / 3, 1); // 3+ goals is ideal
  const completionRate = totalGoals > 0 ? completedGoals / totalGoals : 0;
  const abandonmentPenalty = totalGoals > 0 ? abandonedGoals / totalGoals : 0;

  const goalConsistencyScore = (
    (idealActiveGoals * 0.4) +
    (completionRate * 0.4) -
    (abandonmentPenalty * 0.2)
  ) * 100;

  // 2. Check-in Consistency (25%)
  const checkinsSnapshot = await db
    .collection('users')
    .doc(userId)
    .collection('daily_checkins')
    .orderBy('date', 'desc')
    .limit(30)
    .get();

  const checkins = checkinsSnapshot.docs.map(doc => doc.data());
  const streak = await calculateCurrentStreak(userId);
  const missedDays = 30 - checkins.length;
  const fullCheckins = checkins.filter(c => c.isComplete).length;

  const streakScore = Math.min(streak / 14, 1); // 14+ days is excellent
  const consistencyScore = checkins.length / 30;
  const qualityScore = checkins.length > 0 ? fullCheckins / checkins.length : 0;

  const checkinConsistencyScore = (
    (streakScore * 0.4) +
    (consistencyScore * 0.4) +
    (qualityScore * 0.2)
  ) * 100;

  // 3. Progress Momentum (20%)
  const milestonesSnapshot = await db
    .collectionGroup('milestones')
    .where('userId', '==', userId)
    .where('isCompleted', '==', true)
    .where('completedAt', '>=', admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    ))
    .get();

  const recentMilestones = milestonesSnapshot.docs.length;
  const milestoneScore = Math.min(recentMilestones / 5, 1); // 5+ milestones/month is excellent

  // Calculate average days to milestone
  const avgDaysToMilestone = await calculateAvgMilestoneDuration(userId);
  const speedScore = avgDaysToMilestone > 0 ? Math.max(1 - (avgDaysToMilestone / 30), 0) : 0;

  const progressMomentumScore = (
    (milestoneScore * 0.6) +
    (speedScore * 0.4)
  ) * 100;

  // 4. Social Engagement (15%)
  const sharedMilestones = await db
    .collectionGroup('milestones')
    .where('userId', '==', userId)
    .where('shared', '==', true)
    .where('sharedAt', '>=', admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    ))
    .get();

  const shareScore = Math.min(sharedMilestones.docs.length / 3, 1); // 3+ shares/month

  // Check sponsor engagement
  const sponsorInteractions = await db
    .collection('users')
    .doc(userId)
    .collection('sponsor_interactions')
    .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    ))
    .get();

  const sponsorScore = sponsorInteractions.docs.length > 0 ? 1 : 0;

  const socialEngagementScore = (
    (shareScore * 0.7) +
    (sponsorScore * 0.3)
  ) * 100;

  // 5. AI Adoption (10%)
  const aiInteractions = await db
    .collection('users')
    .doc(userId)
    .collection('ai_interactions')
    .where('type', '==', 'suggestion_accepted')
    .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
    ))
    .get();

  const aiAdoptionScore = Math.min(aiInteractions.docs.length / 5, 1) * 100;

  // Calculate weighted total
  const totalScore =
    (goalConsistencyScore * 0.30) +
    (checkinConsistencyScore * 0.25) +
    (progressMomentumScore * 0.20) +
    (socialEngagementScore * 0.15) +
    (aiAdoptionScore * 0.10);

  return Math.round(totalScore);
}

async function calculateCurrentStreak(userId: string): Promise<number> {
  const db = admin.firestore();
  const userDoc = await db.collection('users').doc(userId).get();
  return userDoc.data()?.checkinStreak || 0;
}

async function calculateAvgMilestoneDuration(userId: string): Promise<number> {
  const db = admin.firestore();

  const milestones = await db
    .collectionGroup('milestones')
    .where('userId', '==', userId)
    .where('isCompleted', '==', true)
    .orderBy('completedAt', 'desc')
    .limit(10)
    .get();

  if (milestones.empty) return 0;

  const durations = milestones.docs.map(doc => {
    const data = doc.data();
    const created = data.createdAt.toDate();
    const completed = data.completedAt.toDate();
    return (completed.getTime() - created.getTime()) / (1000 * 60 * 60 * 24); // days
  });

  return durations.reduce((a, b) => a + b, 0) / durations.length;
}
```

### 10.3 Trust Score Display in Goals UI

```dart
// lib/features/goals/widgets/trust_score_widget.dart
import 'package:flutter/material.dart';

class TrustScoreBadge extends StatelessWidget {
  const TrustScoreBadge({
    super.key,
    required this.score,
    this.showLabel = true,
  });

  final int score;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '$score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            'Trust Score',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ],
    );
  }

  Color _getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}
```

---

## 11. Security & Privacy

### 11.1 Data Privacy Principles

1. **User Ownership**: Users own their goal data
2. **Granular Control**: Per-goal visibility settings
3. **Sponsor Access**: Explicit permission required
4. **AI Transparency**: Users see what AI knows
5. **Data Portability**: Export all goal data anytime
6. **Right to Delete**: Complete data erasure

### 11.2 Firestore Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // User profiles
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;

      // Goals collection
      match /goals/{goalId} {
        // User can always read/write their own goals
        allow read, write: if request.auth.uid == userId;

        // Sponsor can read if permission granted
        allow read: if request.auth != null &&
          exists(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)) &&
          get(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)).data.permissions.viewGoals != 'none';

        // Milestones subcollection
        match /milestones/{milestoneId} {
          allow read, write: if request.auth.uid == userId;

          // Public milestones can be read by anyone
          allow read: if resource.data.visibility == 'public';

          // Sponsor can read based on permissions
          allow read: if request.auth != null &&
            exists(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)) &&
            get(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)).data.permissions.viewMilestones == true;
        }

        // Check-ins subcollection
        match /check_ins/{checkinId} {
          allow read, write: if request.auth.uid == userId;

          // Sponsor can read if permission granted
          allow read: if request.auth != null &&
            exists(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)) &&
            get(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)).data.permissions.viewCheckins == true;
        }
      }

      // Daily check-ins
      match /daily_checkins/{dateKey} {
        allow read, write: if request.auth.uid == userId;

        // Sponsor can read if permission granted
        allow read: if request.auth != null &&
          exists(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)) &&
          get(/databases/$(database)/documents/sponsor_relationships/$(request.auth.uid + '_' + userId)).data.permissions.viewCheckins == true;
      }

      // AI interactions (private to user only)
      match /ai_interactions/{interactionId} {
        allow read, write: if request.auth.uid == userId;
      }

      // Sponsor alerts (user + sponsor can read)
      match /sponsor_alerts/{alertId} {
        allow read: if request.auth.uid == userId ||
          request.auth.uid == resource.data.sponsorId;
        allow create: if request.auth.uid == userId;
      }
    }

    // Sponsor relationships
    match /sponsor_relationships/{relationshipId} {
      allow read: if request.auth.uid == resource.data.sponsorId ||
                     request.auth.uid == resource.data.sponsoredUserId;
      allow create: if request.auth.uid == request.resource.data.sponsoredUserId;
      allow update: if request.auth.uid == resource.data.sponsoredUserId;
      allow delete: if request.auth.uid == resource.data.sponsoredUserId ||
                       request.auth.uid == resource.data.sponsorId;
    }

    // My Struggle posts (respects visibility settings)
    match /my_struggle_posts/{postId} {
      allow read: if resource.data.visibility == 'public' ||
                     (resource.data.visibility == 'connections' &&
                      exists(/databases/$(database)/documents/connections/$(request.auth.uid + '_' + resource.data.userId))) ||
                     request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }

    // Giving transactions (users can read their own)
    match /giving_transactions/{transactionId} {
      allow read: if request.auth.uid == resource.data.giverId ||
                     request.auth.uid == resource.data.recipientId;
      allow create: if request.auth.uid == request.resource.data.giverId;
    }
  }
}
```

### 11.3 Data Export Function

```typescript
// functions/src/privacy/export-user-data.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const exportUserGoalData = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const userId = context.auth.uid;
    const db = admin.firestore();

    // Collect all goal-related data
    const exportData: any = {
      exportedAt: new Date().toISOString(),
      userId,
    };

    // Goals
    const goalsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .get();

    exportData.goals = goalsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    // For each goal, get milestones and check-ins
    for (const goalDoc of goalsSnapshot.docs) {
      const goalId = goalDoc.id;

      // Milestones
      const milestonesSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .get();

      exportData.goals.find((g: any) => g.id === goalId).milestones =
        milestonesSnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
        }));

      // Check-ins
      const checkinsSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('check_ins')
        .get();

      exportData.goals.find((g: any) => g.id === goalId).checkIns =
        checkinsSnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
        }));
    }

    // Daily check-ins
    const dailyCheckinsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('daily_checkins')
      .get();

    exportData.dailyCheckins = dailyCheckinsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    // AI interactions
    const aiInteractionsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('ai_interactions')
      .get();

    exportData.aiInteractions = aiInteractionsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    return {
      success: true,
      data: exportData,
    };
  }
);
```

### 11.4 Data Deletion Function

```typescript
// functions/src/privacy/delete-user-data.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const deleteUserGoalData = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const userId = context.auth.uid;
    const db = admin.firestore();
    const batch = db.batch();

    // Delete all goals and subcollections
    const goalsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .get();

    for (const goalDoc of goalsSnapshot.docs) {
      // Delete milestones
      const milestonesSnapshot = await goalDoc.ref
        .collection('milestones')
        .get();
      milestonesSnapshot.docs.forEach(doc => batch.delete(doc.ref));

      // Delete check-ins
      const checkinsSnapshot = await goalDoc.ref
        .collection('check_ins')
        .get();
      checkinsSnapshot.docs.forEach(doc => batch.delete(doc.ref));

      // Delete goal itself
      batch.delete(goalDoc.ref);
    }

    // Delete daily check-ins
    const dailyCheckinsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('daily_checkins')
      .get();
    dailyCheckinsSnapshot.docs.forEach(doc => batch.delete(doc.ref));

    // Delete AI interactions
    const aiInteractionsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('ai_interactions')
      .get();
    aiInteractionsSnapshot.docs.forEach(doc => batch.delete(doc.ref));

    // Commit deletion
    await batch.commit();

    return {
      success: true,
      message: 'All goal data deleted',
    };
  }
);
```

---

## 12. Implementation Roadmap

### 12.1 Phase 1: Foundation (Weeks 1-3)

**Sprint 1: Data Model & Core CRUD**
- [ ] Set up Firebase collections for goals, milestones, check-ins
- [ ] Implement Firestore security rules
- [ ] Create Goal CRUD operations (Create, Read, Update, Delete)
- [ ] Create Milestone CRUD operations
- [ ] Build basic Goal list UI
- [ ] Build Goal detail page

**Sprint 2: Daily Check-In MVP**
- [ ] Design check-in flow UI
- [ ] Implement morning mood check-in
- [ ] Implement goal progress updates
- [ ] Implement evening reflection
- [ ] Save check-in data to Firestore
- [ ] Update goal streaks based on check-ins

**Sprint 3: Starter Goal Library**
- [ ] Define all 40+ starter goal templates
- [ ] Build goal template selector UI
- [ ] Implement "Create from Template" flow
- [ ] Add milestone auto-generation from templates
- [ ] Test goal creation from each category

### 12.2 Phase 2: Intelligence (Weeks 4-6)

**Sprint 4: AI Integration Foundation**
- [ ] Set up OpenAI API integration
- [ ] Implement AI context builder
- [ ] Build daily insight generation
- [ ] Create AI coaching UI components
- [ ] Test AI suggestion quality

**Sprint 5: Smart Features**
- [ ] Implement barrier analysis
- [ ] Build goal suggestion engine
- [ ] Create crisis detection system
- [ ] Implement adaptive milestone recommendations
- [ ] Add AI feedback collection

**Sprint 6: Trust Score Integration**
- [ ] Implement trust score calculation algorithm
- [ ] Build goal-based scoring factors
- [ ] Create trust score display widget
- [ ] Add trust score trend visualization
- [ ] Connect to sponsor visibility

### 12.3 Phase 3: Social Integration (Weeks 7-9)

**Sprint 7: Sponsor Dashboard**
- [ ] Build sponsor relationship data model
- [ ] Create sponsor permission settings UI
- [ ] Implement sponsor dashboard page
- [ ] Build sponsoree detail view
- [ ] Add sponsor alerts system

**Sprint 8: My Struggle Integration**
- [ ] Design milestone sharing flow
- [ ] Build share-to-feed UI
- [ ] Create goal milestone post card
- [ ] Implement visibility controls
- [ ] Add sharing notifications

**Sprint 9: Giving System**
- [ ] Implement credit earning rules
- [ ] Build give-from-milestone UI
- [ ] Create giving transaction logging
- [ ] Add giving notifications
- [ ] Build giving history view

### 12.4 Phase 4: Polish & Scale (Weeks 10-12)

**Sprint 10: UI/UX Refinement**
- [ ] Conduct user testing sessions
- [ ] Implement feedback from testing
- [ ] Polish animations and transitions
- [ ] Optimize mobile responsiveness
- [ ] Accessibility audit and fixes

**Sprint 11: Performance & Reliability**
- [ ] Implement data caching strategies
- [ ] Optimize Firestore queries
- [ ] Add offline support
- [ ] Implement error handling
- [ ] Load testing and optimization

**Sprint 12: Launch Prep**
- [ ] Write user documentation
- [ ] Create onboarding tutorial
- [ ] Set up analytics tracking
- [ ] Final security review
- [ ] Beta testing with real users
- [ ] Production deployment

### 12.5 Success Metrics

**Engagement Metrics**
- Daily active users completing check-ins (target: 60%)
- Average goals per active user (target: 2-4)
- Check-in streak retention (target: 50% reach 7 days)

**Behavioral Metrics**
- Milestone completion rate (target: 70%)
- Goal abandonment rate (target: <20%)
- AI suggestion acceptance rate (target: 30%)

**Social Metrics**
- Milestones shared to My Struggle (target: 40%)
- Giving transactions per milestone (target: 0.5)
- Sponsor engagement rate (target: 80% weekly)

**Trust Score Impact**
- Correlation between goal usage and trust score (target: r > 0.6)
- Trust score improvement over 30 days (target: +10 points)

---

## 13. API Routes

### 13.1 Cloud Functions Overview

All goal-related backend logic is implemented as Firebase Cloud Functions:

```
functions/
├── src/
│   ├── goals/
│   │   ├── create-goal.ts
│   │   ├── update-goal.ts
│   │   ├── complete-milestone.ts
│   │   └── archive-goal.ts
│   ├── checkins/
│   │   ├── submit-checkin.ts
│   │   ├── update-streaks.ts
│   │   └── send-reminders.ts
│   ├── ai/
│   │   ├── generate-insights.ts
│   │   ├── suggest-goals.ts
│   │   ├── analyze-barriers.ts
│   │   └── detect-crisis.ts
│   ├── sponsor/
│   │   ├── get-dashboard-data.ts
│   │   ├── send-alert.ts
│   │   └── update-permissions.ts
│   ├── trust-score/
│   │   ├── calculate-goal-score.ts
│   │   └── update-trust-score.ts
│   ├── giving/
│   │   ├── award-credits.ts
│   │   ├── process-transaction.ts
│   │   └── send-notification.ts
│   └── privacy/
│       ├── export-data.ts
│       └── delete-data.ts
```

### 13.2 Goal Management Functions

```typescript
// functions/src/goals/create-goal.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const createGoal = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const {
      title,
      description,
      category,
      type,
      targetDate,
      milestones,
      visibility,
      linkedNeedId,
    } = data;

    const userId = context.auth.uid;
    const db = admin.firestore();

    // Validate input
    if (!title || !category || !type) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Missing required fields'
      );
    }

    // Create goal document
    const goalRef = db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc();

    const goalData = {
      goalId: goalRef.id,
      userId,
      title,
      description: description || null,
      category,
      type,
      status: 'active',
      targetDate: targetDate ? admin.firestore.Timestamp.fromDate(new Date(targetDate)) : null,
      startDate: admin.firestore.FieldValue.serverTimestamp(),
      completedAt: null,
      currentStreak: 0,
      completionRate: 0,
      visibility: visibility || {
        level: 'private',
        sponsorCanComment: false,
      },
      linkedNeedId: linkedNeedId || null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await goalRef.set(goalData);

    // Create milestones if provided
    if (milestones && milestones.length > 0) {
      const batch = db.batch();

      milestones.forEach((milestone: any, index: number) => {
        const milestoneRef = goalRef.collection('milestones').doc();
        batch.set(milestoneRef, {
          milestoneId: milestoneRef.id,
          goalId: goalRef.id,
          userId,
          title: milestone.title,
          description: milestone.description || null,
          order: index,
          isCompleted: false,
          completedAt: null,
          visibility: milestone.visibility || visibility.level,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();
    }

    // Log activity
    await db
      .collection('users')
      .doc(userId)
      .collection('activity')
      .add({
        type: 'goal_created',
        goalId: goalRef.id,
        goalTitle: title,
        category,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Trigger trust score recalculation
    await db
      .collection('trust_score_queue')
      .add({
        userId,
        reason: 'goal_created',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    return {
      success: true,
      goalId: goalRef.id,
    };
  }
);
```

```typescript
// functions/src/goals/complete-milestone.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const completeMilestone = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const { goalId, milestoneId, celebrationNote } = data;
    const userId = context.auth.uid;
    const db = admin.firestore();

    // Get milestone
    const milestoneRef = db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc(goalId)
      .collection('milestones')
      .doc(milestoneId);

    const milestoneDoc = await milestoneRef.get();

    if (!milestoneDoc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'Milestone not found'
      );
    }

    // Mark as completed
    await milestoneRef.update({
      isCompleted: true,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
      celebrationNote: celebrationNote || null,
    });

    // Update goal completion rate
    await updateGoalCompletionRate(userId, goalId);

    // Award giving credits
    await awardGivingCredits(userId, 'milestone_completed', 10, milestoneId);

    // Check if this was the first milestone
    const allMilestonesSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc(goalId)
      .collection('milestones')
      .where('isCompleted', '==', true)
      .get();

    if (allMilestonesSnapshot.docs.length === 1) {
      // First milestone bonus
      await awardGivingCredits(userId, 'first_milestone', 5, milestoneId);
    }

    // Send to sponsor if appropriate
    const goalDoc = await db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc(goalId)
      .get();

    const goalData = goalDoc.data();

    // Check for sponsor relationships
    const sponsorships = await db
      .collection('sponsor_relationships')
      .where('sponsoredUserId', '==', userId)
      .where('status', '==', 'active')
      .get();

    for (const sponsorshipDoc of sponsorships.docs) {
      const sponsorship = sponsorshipDoc.data();

      if (sponsorship.alertPreferences?.milestoneCompleted) {
        await db
          .collection('users')
          .doc(userId)
          .collection('sponsor_alerts')
          .add({
            sponsorId: sponsorship.sponsorId,
            type: 'milestone_completed',
            severity: 'low',
            goalTitle: goalData?.title,
            milestoneTitle: milestoneDoc.data().title,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            acknowledged: false,
          });
      }
    }

    // Trigger trust score update
    await db
      .collection('trust_score_queue')
      .add({
        userId,
        reason: 'milestone_completed',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    return {
      success: true,
      creditsEarned: allMilestonesSnapshot.docs.length === 1 ? 15 : 10,
    };
  }
);

async function updateGoalCompletionRate(userId: string, goalId: string) {
  const db = admin.firestore();

  const milestonesSnapshot = await db
    .collection('users')
    .doc(userId)
    .collection('goals')
    .doc(goalId)
    .collection('milestones')
    .get();

  const total = milestonesSnapshot.docs.length;
  const completed = milestonesSnapshot.docs.filter(
    doc => doc.data().isCompleted
  ).length;

  const completionRate = total > 0 ? (completed / total) * 100 : 0;

  await db
    .collection('users')
    .doc(userId)
    .collection('goals')
    .doc(goalId)
    .update({
      completionRate,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

  // Check if goal is now complete
  if (completionRate === 100) {
    await db
      .collection('users')
      .doc(userId)
      .collection('goals')
      .doc(goalId)
      .update({
        status: 'completed',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Award goal completion bonus
    await awardGivingCredits(userId, 'goal_completed', 50, goalId);
  }
}

async function awardGivingCredits(
  userId: string,
  source: string,
  amount: number,
  sourceId: string
) {
  const db = admin.firestore();

  await db.collection('users').doc(userId).update({
    givingCredits: admin.firestore.FieldValue.increment(amount),
  });

  await db
    .collection('users')
    .doc(userId)
    .collection('giving_transactions')
    .add({
      type: 'earned',
      amount,
      source,
      sourceId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}
```

### 13.3 Check-In Functions

```typescript
// functions/src/checkins/submit-checkin.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const submitCheckin = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const userId = context.auth.uid;
    const db = admin.firestore();
    const dateKey = new Date().toISOString().split('T')[0];

    // Save check-in
    const checkinRef = db
      .collection('users')
      .doc(userId)
      .collection('daily_checkins')
      .doc(dateKey);

    await checkinRef.set({
      ...data,
      userId,
      date: dateKey,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
      isComplete: true,
    });

    // Update goal streaks
    if (data.goalUpdates && data.goalUpdates.length > 0) {
      const batch = db.batch();

      for (const update of data.goalUpdates) {
        if (update.status === 'completed' || update.status === 'partial') {
          const goalRef = db
            .collection('users')
            .doc(userId)
            .collection('goals')
            .doc(update.goalId);

          batch.update(goalRef, {
            currentStreak: admin.firestore.FieldValue.increment(1),
            lastCheckinDate: dateKey,
          });
        }
      }

      await batch.commit();
    }

    // Update user check-in streak
    await updateUserStreak(userId, dateKey);

    // Generate AI insight (async)
    generateDailyInsight(userId).catch(console.error);

    // Trigger trust score update
    await db
      .collection('trust_score_queue')
      .add({
        userId,
        reason: 'checkin_completed',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    return {
      success: true,
    };
  }
);

async function updateUserStreak(userId: string, dateKey: string) {
  const db = admin.firestore();
  const userRef = db.collection('users').doc(userId);
  const userDoc = await userRef.get();
  const userData = userDoc.data();

  const lastCheckinDate = userData?.lastCheckinDate;
  const currentStreak = userData?.checkinStreak || 0;

  if (!lastCheckinDate) {
    // First check-in
    await userRef.update({
      checkinStreak: 1,
      lastCheckinDate: dateKey,
    });
    return;
  }

  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayKey = yesterday.toISOString().split('T')[0];

  if (lastCheckinDate === yesterdayKey) {
    // Continuing streak
    const newStreak = currentStreak + 1;
    await userRef.update({
      checkinStreak: newStreak,
      lastCheckinDate: dateKey,
    });

    // Award streak bonuses
    if (newStreak === 7) {
      await awardGivingCredits(userId, 'checkin_streak_7', 25, dateKey);
    } else if (newStreak === 14) {
      await awardGivingCredits(userId, 'checkin_streak_14', 50, dateKey);
    } else if (newStreak === 30) {
      await awardGivingCredits(userId, 'checkin_streak_30', 100, dateKey);
    }
  } else if (lastCheckinDate === dateKey) {
    // Same day, no change
    return;
  } else {
    // Streak broken
    await userRef.update({
      checkinStreak: 1,
      lastCheckinDate: dateKey,
    });
  }
}

async function generateDailyInsight(userId: string) {
  const db = admin.firestore();

  // Call AI coaching engine
  const CoachingEngine = require('../ai/coaching-engine').CoachingEngine;
  const engine = new CoachingEngine();

  const insight = await engine.generateDailyInsight(userId);

  // Save insight
  await db
    .collection('users')
    .doc(userId)
    .collection('daily_insights')
    .add({
      insight,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
    });
}
```

---

## 14. UI/UX Specifications

### 14.1 Design System

**Colors**
- Primary: Blue (#2196F3) - Trust, progress, calm
- Secondary: Green (#4CAF50) - Growth, completion, success
- Accent: Amber (#FFC107) - Milestones, achievements
- Error: Red (#F44336) - Warnings, missed items
- Background: White (#FFFFFF) / Dark (#121212)

**Typography**
- Headings: Inter, Bold, 24-32px
- Body: Inter, Regular, 14-16px
- Captions: Inter, Medium, 12px
- Labels: Inter, SemiBold, 10px, UPPERCASE

**Spacing System**
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px

**Border Radius**
- Small: 8px (chips, badges)
- Medium: 12px (cards)
- Large: 16px (modals, sheets)
- Circle: 50% (avatars, icons)

### 14.2 Component Specifications

**Goal Card**
```
┌────────────────────────────────────────┐
│ [Icon] CATEGORY LABEL        [Status] │
│                                        │
│ Goal Title (Large, Bold)               │
│                                        │
│ 75% complete • 12 day streak           │
│ ████████████░░░░                       │
│                                        │
│ Due in 5 days                          │
└────────────────────────────────────────┘

Dimensions:
- Height: Auto (min 120px)
- Padding: 16px
- Elevation: 2dp
- Border Radius: 12px
```

**Milestone List Item**
```
┌────────────────────────────────────────┐
│ ☐ Milestone title                      │
│   Description text (gray, smaller)     │
│   [Progress indicator if applicable]   │
└────────────────────────────────────────┘

States:
- Uncompleted: Gray checkbox
- Completed: Green checkmark, strikethrough title
- Current: Blue accent border
```

**Daily Check-In Flow**
```
Page 1: Mood Check-In
─────────────────────────────
Progress: ████░░░░ (25%)

How are you feeling today?

[😞] [😐] [🙂] [😊] [😁]
(tap to select)

Optional note:
┌─────────────────────┐
│                     │
│                     │
└─────────────────────┘

         [Back] [Next →]
```

**Sponsor Dashboard Card**
```
┌────────────────────────────────────────┐
│ [Avatar] John Doe              [2] 🔔 │
│          45 days in recovery           │
│                                        │
│ ┌──────┐ ┌──────┐ ┌──────┐            │
│ │  3   │ │  7   │ │  82  │            │
│ │Goals │ │Streak│ │Trust │            │
│ └──────┘ └──────┘ └──────┘            │
│                                        │
│ ✓ Checked in today                    │
│ ↗ Mood: improving                     │
└────────────────────────────────────────┘
```

### 14.3 Interaction Patterns

**Swipe Actions on Goal Card**
- Swipe left: Archive, Delete (destructive)
- Swipe right: Complete, Share (positive)

**Long Press on Milestone**
- Quick complete
- Edit
- Delete
- Share

**Pull to Refresh**
- Goals list page
- Check-in history
- Sponsor dashboard

**Empty States**
- No goals: Show starter templates, big CTA
- No check-ins: Encourage first check-in
- No milestones: Prompt to add or use AI

### 14.4 Accessibility Requirements

- All interactive elements minimum 44x44px tap target
- Color contrast ratio 4.5:1 minimum
- Screen reader labels on all icons
- Keyboard navigation support (web)
- Focus indicators visible
- Error messages read aloud
- Form fields with clear labels
- Support for text scaling (up to 200%)

---

## 15. Testing Strategy

### 15.1 Unit Tests

```typescript
// tests/unit/goal-creation.test.ts

import { createGoal } from '../../functions/src/goals/create-goal';
import * as admin from 'firebase-admin';

describe('Goal Creation', () => {
  let db: admin.firestore.Firestore;

  beforeAll(() => {
    // Initialize test environment
  });

  test('should create goal with valid data', async () => {
    const result = await createGoal({
      title: 'Test Goal',
      category: 'recovery',
      type: 'continuous',
    }, {
      auth: { uid: 'test-user-id' },
    });

    expect(result.success).toBe(true);
    expect(result.goalId).toBeDefined();
  });

  test('should reject goal without title', async () => {
    await expect(
      createGoal({
        category: 'recovery',
        type: 'continuous',
      }, {
        auth: { uid: 'test-user-id' },
      })
    ).rejects.toThrow();
  });

  test('should create milestones when provided', async () => {
    const result = await createGoal({
      title: 'Test Goal',
      category: 'recovery',
      type: 'milestone',
      milestones: [
        { title: 'Milestone 1' },
        { title: 'Milestone 2' },
      ],
    }, {
      auth: { uid: 'test-user-id' },
    });

    const milestonesSnapshot = await db
      .collection('users')
      .doc('test-user-id')
      .collection('goals')
      .doc(result.goalId)
      .collection('milestones')
      .get();

    expect(milestonesSnapshot.docs.length).toBe(2);
  });
});
```

```dart
// test/widget/goal_card_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:newfreedom/features/goals/widgets/goal_card.dart';

void main() {
  testWidgets('GoalCard displays goal information', (WidgetTester tester) async {
    final goal = Goal(
      goalId: 'test-id',
      title: 'Test Goal',
      category: GoalCategory.recovery,
      status: 'active',
      completionRate: 75,
      currentStreak: 5,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(goal: goal),
        ),
      ),
    );

    expect(find.text('Test Goal'), findsOneWidget);
    expect(find.text('75% complete'), findsOneWidget);
    expect(find.text('5 day streak'), findsOneWidget);
  });

  testWidgets('GoalCard shows correct status badge', (WidgetTester tester) async {
    final goal = Goal(
      goalId: 'test-id',
      title: 'Test Goal',
      category: GoalCategory.recovery,
      status: 'completed',
      completionRate: 100,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(goal: goal),
        ),
      ),
    );

    expect(find.text('COMPLETED'), findsOneWidget);
  });
}
```

### 15.2 Integration Tests

```dart
// integration_test/goal_flow_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:newfreedom/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete goal creation and check-in flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to goals page
    await tester.tap(find.text('Goals'));
    await tester.pumpAndSettle();

    // Tap create goal button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in goal details
    await tester.enterText(
      find.byKey(Key('goal-title-field')),
      'Test Integration Goal',
    );
    await tester.tap(find.text('Recovery'));
    await tester.pumpAndSettle();

    // Submit goal
    await tester.tap(find.text('Create Goal'));
    await tester.pumpAndSettle();

    // Verify goal appears in list
    expect(find.text('Test Integration Goal'), findsOneWidget);

    // Open daily check-in
    await tester.tap(find.byIcon(Icons.check_circle));
    await tester.pumpAndSettle();

    // Select mood
    await tester.tap(find.byIcon(Icons.sentiment_satisfied));
    await tester.pumpAndSettle();

    // Next to goal review
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Mark goal as completed
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    // Complete check-in
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();

    // Verify streak updated
    expect(find.text('1 day streak'), findsOneWidget);
  });
}
```

### 15.3 E2E Test Scenarios

**Critical User Journeys**

1. **New User First Goal**
   - Sign up
   - Complete onboarding
   - Browse starter templates
   - Create first goal from template
   - View goal detail
   - Complete first daily check-in

2. **Milestone Completion & Sharing**
   - Navigate to active goal
   - Complete a milestone
   - See celebration modal
   - Choose to share
   - Verify post in My Struggle feed
   - Check giving credits awarded

3. **Sponsor Visibility**
   - User grants sponsor access
   - Sponsor views dashboard
   - Sponsor sees sponsoree goals
   - Sponsor receives milestone alert
   - Sponsor sends encouragement message
   - User receives notification

4. **AI Coaching**
   - Complete multiple check-ins
   - View daily insight
   - Receive goal suggestion
   - Accept suggestion
   - Create goal from AI recommendation

5. **Trust Score Impact**
   - Start with baseline trust score
   - Complete check-in streak
   - Complete milestones
   - View trust score increase
   - See impact on sponsor visibility

### 15.4 Performance Testing

**Load Testing Targets**
- 1000 concurrent users creating goals
- 5000 daily check-ins submitted simultaneously
- Trust score calculation under 2 seconds
- AI insight generation under 5 seconds
- Page load time under 2 seconds

**Firestore Query Optimization**
- Index all frequently queried fields
- Use composite indexes for complex queries
- Implement pagination for large lists
- Cache frequently accessed data

**Monitoring & Alerts**
- Firebase Performance Monitoring
- Crashlytics for error tracking
- Cloud Function execution times
- Firestore read/write quotas
- OpenAI API usage and costs

---

## Conclusion

This comprehensive architecture provides a complete blueprint for implementing the Goal Tracking System in the NewFreedom platform. The system is designed to:

1. **Empower users** with flexible, customizable goal tracking
2. **Support recovery** through daily check-ins and AI coaching
3. **Foster accountability** via sponsor visibility and transparency
4. **Drive engagement** through giving system integration
5. **Build trust** by contributing to trust score calculations

### Next Steps

1. **Review & Refine**: Gather feedback on this architecture from stakeholders
2. **Prioritize Features**: Decide which features are MVP vs. future enhancements
3. **Assemble Team**: Identify developers, designers, and testers needed
4. **Begin Implementation**: Start with Phase 1 foundation work
5. **Iterate Based on Usage**: Collect user feedback and adjust roadmap

### Estimated Timeline

- **Phase 1 (Foundation)**: 3 weeks
- **Phase 2 (Intelligence)**: 3 weeks
- **Phase 3 (Social Integration)**: 3 weeks
- **Phase 4 (Polish & Scale)**: 3 weeks

**Total**: ~12 weeks to full launch

### Estimated Resources

- 2 Full-stack developers (Flutter + Firebase)
- 1 UI/UX designer
- 1 QA engineer
- Part-time AI/ML support for coaching features

---

**Document Version**: 1.0
**Last Updated**: February 15, 2026
**Author**: Claude (NewFreedom AI Architecture Team)
**Status**: Ready for Review & Implementation
