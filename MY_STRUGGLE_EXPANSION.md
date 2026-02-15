# My Struggle Expansion - Comprehensive Architecture Plan

**Date**: February 15, 2026
**Project**: NewFreedom → Full Reentry Ecosystem
**Scope**: Social Community + Giving System + Sponsorship + Marketplace + Enhanced AI

---

## Executive Summary

This document outlines the architectural plan to transform NewFreedom from a **personal recovery tool** into a **full reentry ecosystem** by integrating core "My Struggle" components.

### Current Platform (Phase 1)
- Interactive Step Experience (ISE) - 12-step video journey
- Goal tracking with daily AI check-ins
- Personal accountability system
- Anonymous users
- Single AI agent

### Expanded Platform (Phase 2+)
- **Social Community** - Posts, comments, groups, messaging
- **Giving System** - Micro-funding for verified needs
- **Sponsorship Network** - Structured mentor matching
- **Public Profiles** - Identity + trust scoring
- **Support Marketplace** - Jobs, housing, services
- **AI Orchestrator** - From accountability to ecosystem manager
- **Safety Infrastructure** - Moderation, crisis detection, abuse prevention

### Strategic Vision
Not just a recovery app.
**A structured return-to-society platform.**

---

## 1. Expanded Data Model

This expansion requires **10+ new Firestore collections** and significant schema changes.

### 1.1 Core Collections Overview

```
users/{uid}                          # User accounts
├─ profile                           # Public profile data
├─ privacy_settings                  # Visibility controls
├─ trust_score                       # Credibility metrics
├─ goals/{goalId}                    # Existing goals system
├─ checkins/{checkinId}              # Existing check-ins
├─ ise_progress/{stepId}             # Existing ISE tracking
├─ funding_requests/{requestId}      # NEW: Giving system
├─ sponsorships/{sponsorshipId}      # NEW: Mentorship
├─ posts/{postId}                    # NEW: Social posts
└─ messages/{conversationId}         # NEW: Direct messaging

posts/{postId}                       # NEW: Community posts
├─ content                           # Post data
├─ author                            # User reference
├─ comments/{commentId}              # Nested comments
└─ reactions/{userId}                # Likes, etc.

groups/{groupId}                     # NEW: Community groups
├─ metadata                          # Group info
├─ members/{userId}                  # Group members
└─ posts/{postId}                    # Group-specific posts

funding_requests/{requestId}         # NEW: Support requests
├─ request_data                      # Need details
├─ goal_link                         # Linked goal
├─ sponsors/{sponsorId}              # Funding contributions
└─ verification                      # Approval status

sponsorships/{sponsorshipId}         # NEW: Mentor relationships
├─ sponsor_uid                       # Mentor
├─ mentee_uid                        # Participant
├─ status                            # Active, paused, ended
└─ messages/{messageId}              # Sponsor-mentee chat

marketplace/{listingId}              # NEW: Jobs/housing/services
├─ listing_data                      # Details
├─ organization                      # Posting org
├─ applications/{userId}             # User applications
└─ verification                      # Verified listing

moderation/{reportId}                # NEW: Content moderation
├─ report_data                       # Report details
├─ content_ref                       # Reference to flagged content
├─ status                            # Pending, resolved, escalated
└─ moderator_notes                   # Admin notes

notifications/{notificationId}       # NEW: User notifications
├─ recipient_uid                     # User
├─ type                              # Comment, reaction, funding, etc.
├─ content                           # Notification data
└─ read                              # Read status

trust_scores/{uid}                   # NEW: Trust scoring system
├─ overall_score                     # 0-100
├─ components                        # Breakdown
├─ history                           # Score changes
└─ verification                      # Identity verification status
```

---

## 2. Social Community System

### 2.1 User Profile Schema

```typescript
type UserProfile = {
  uid: string;
  displayName: string;
  profilePhoto?: string;
  bio?: string;
  location?: string; // City/State only

  // Recovery Status (optional visibility)
  recoveryStatus?: 'in_recovery' | 'reentry' | 'sober_living' | 'general';
  sobrietyDate?: timestamp;
  programType?: string;

  // Sponsor/Mentor Status
  isSponsor: boolean;
  isMentor: boolean;
  mentorTypes?: ('recovery' | 'life' | 'career' | 'faith' | 'neutral')[];

  // Preferences
  tonePreference?: 'faith' | 'hybrid' | 'neutral';
  genderPreference?: 'male' | 'female' | 'any';

  // Visibility
  profileVisibility: 'public' | 'community_only' | 'sponsors_only' | 'private';
  goalVisibility: 'public' | 'sponsors_only' | 'private';

  // Stats
  joinedAt: timestamp;
  lastActive: timestamp;
  postsCount: number;
  goalsCompleted: number;
  daysClean?: number;

  // Trust & Verification
  trustScore: number; // 0-100
  verified: boolean;
  verificationDate?: timestamp;

  // Flags
  suspended: boolean;
  suspendedUntil?: timestamp;
  suspensionReason?: string;
}
```

### 2.2 Post Schema

```typescript
type Post = {
  id: string;
  authorUid: string;
  authorName: string;
  authorPhoto?: string;

  // Content
  type: 'progress' | 'reflection' | 'milestone' | 'need_request' | 'gratitude' | 'sponsorship_offer' | 'mentorship_offer' | 'general';
  content: string; // Main text
  media?: string[]; // Image/video URLs

  // Linked Data
  linkedGoal?: string; // Goal ID if milestone
  linkedFundingRequest?: string; // Funding request ID if need
  linkedISEStep?: number; // ISE step if reflection

  // Engagement
  reactionsCount: number;
  commentsCount: number;
  sharesCount: number;

  // Visibility
  visibility: 'public' | 'community_only' | 'sponsors_only';
  groupId?: string; // If posted to a group

  // Moderation
  flaggedCount: number;
  moderationStatus: 'approved' | 'pending' | 'flagged' | 'removed';
  moderatedBy?: string;
  moderatedAt?: timestamp;

  // Timestamps
  createdAt: timestamp;
  updatedAt: timestamp;
  pinnedAt?: timestamp;
}
```

### 2.3 Comment Schema

```typescript
type Comment = {
  id: string;
  postId: string;
  authorUid: string;
  authorName: string;
  authorPhoto?: string;

  content: string;
  parentCommentId?: string; // For nested replies

  reactionsCount: number;
  flaggedCount: number;

  moderationStatus: 'approved' | 'pending' | 'removed';

  createdAt: timestamp;
  updatedAt: timestamp;
}
```

### 2.4 Group Schema

```typescript
type Group = {
  id: string;
  name: string;
  description: string;
  coverPhoto?: string;

  // Type
  type: 'recovery' | 'reentry' | 'employment' | 'housing' | 'faith' | 'general';
  tags: string[];

  // Membership
  memberCount: number;
  privacy: 'public' | 'closed' | 'secret';
  requiresApproval: boolean;

  // Admins
  creatorUid: string;
  adminUids: string[];
  moderatorUids: string[];

  // Rules
  rules: string[];

  // Moderation
  moderationLevel: 'strict' | 'moderate' | 'relaxed';

  createdAt: timestamp;
  updatedAt: timestamp;
}
```

### 2.5 Direct Messaging Schema

```typescript
type Conversation = {
  id: string;
  participants: string[]; // UIDs (2 for DM, 2+ for group chat)
  participantNames: Record<string, string>;

  lastMessage: string;
  lastMessageAt: timestamp;
  lastMessageBy: string;

  // Moderation
  monitored: boolean; // All DMs lightly monitored by AI
  flagged: boolean;
  flagReason?: string;

  createdAt: timestamp;
  updatedAt: timestamp;
}

type Message = {
  id: string;
  conversationId: string;
  senderUid: string;
  senderName: string;

  content: string;
  media?: string[];

  // Moderation
  moderationStatus: 'approved' | 'pending' | 'flagged' | 'removed';
  aiRiskScore?: number; // 0-100 (drug sourcing, violence detection)

  // Read Receipts
  readBy: Record<string, timestamp>;

  createdAt: timestamp;
  deletedAt?: timestamp;
}
```

---

## 3. Giving System Architecture

### 3.1 Funding Request Schema

```typescript
type FundingRequest = {
  id: string;
  requesterUid: string;
  requesterName: string;
  requesterPhoto?: string;

  // Request Details
  title: string; // "Birth Certificate"
  description: string;
  amount: number; // In cents (e.g., 3500 for $35)
  category: 'legal_docs' | 'transportation' | 'housing' | 'employment' | 'education' | 'recovery' | 'general';

  // Linked Goal
  linkedGoalId?: string;
  goalTitle?: string;

  // Funding Progress
  amountFunded: number; // In cents
  fundingGoal: number; // In cents
  fullyFunded: boolean;

  // Sponsors
  sponsorCount: number;

  // Verification
  verified: boolean;
  verifiedBy?: string; // Admin UID
  verifiedAt?: timestamp;

  // Disbursement
  disbursementMethod: 'vendor' | 'controlled_payout' | 'reimbursement';
  vendorName?: string;
  vendorContact?: string;

  status: 'pending_verification' | 'active' | 'funded' | 'disbursed' | 'completed' | 'cancelled';

  // Receipts
  receiptUrl?: string;
  receiptVerified: boolean;

  // Moderation
  flaggedCount: number;
  suspicionScore?: number; // AI-generated risk score

  createdAt: timestamp;
  fundedAt?: timestamp;
  disbursedAt?: timestamp;
  completedAt?: timestamp;
}
```

### 3.2 Funding Contribution Schema

```typescript
type FundingContribution = {
  id: string;
  requestId: string;

  // Sponsor
  sponsorUid: string;
  sponsorName: string;
  sponsorAnonymous: boolean;

  // Amount
  amount: number; // In cents
  platformFee: number; // In cents (optional)
  totalCharged: number; // In cents

  // Payment
  paymentMethod: 'stripe' | 'paypal';
  paymentIntentId: string;
  paymentStatus: 'pending' | 'succeeded' | 'failed' | 'refunded';

  // Message
  message?: string; // Optional message to recipient

  createdAt: timestamp;
  processedAt?: timestamp;
}
```

### 3.3 Giving System Flow

```
┌─────────────────────────────────────────────────┐
│  USER CREATES FUNDING REQUEST                   │
│  - Links to active goal                         │
│  - Specifies need + amount                      │
│  - Chooses disbursement method                  │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  AI VALIDATION                                  │
│  - Checks if goal is active                     │
│  - Checks for duplicate requests                │
│  - Checks trust score threshold                 │
│  - Flags suspicious patterns                    │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  ADMIN VERIFICATION (if needed)                 │
│  - Reviews request                              │
│  - Approves or denies                           │
│  - Sets disbursement method                     │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  REQUEST GOES LIVE IN MARKETPLACE               │
│  - Visible to sponsors                          │
│  - Shows funding progress                       │
│  - Shows requester profile + trust score        │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  SPONSOR CONTRIBUTES                            │
│  - Chooses amount                               │
│  - Optional message                             │
│  - Payment via Stripe                           │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  FUNDS HELD IN ESCROW                           │
│  - Not immediately released                     │
│  - Awaits verification                          │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  DISBURSEMENT                                   │
│  Option 1: Direct to vendor                     │
│  Option 2: Controlled payout (admin approval)   │
│  Option 3: Reimbursement (receipt required)     │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  RECEIPT VERIFICATION                           │
│  - User uploads receipt                         │
│  - Admin/AI verifies                            │
│  - Trust score updated                          │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│  REQUEST MARKED COMPLETE                        │
│  - User can post gratitude                      │
│  - Sponsors notified                            │
│  - Impact metrics updated                       │
└─────────────────────────────────────────────────┘
```

### 3.4 Giving System Safeguards

**Prevent Misuse:**
1. **Goal-Based Requests Only** - Must link to active, verified goal
2. **Trust Score Threshold** - Minimum score (e.g., 50) to request funding
3. **Request Limits** - Max 3 active requests at once
4. **Amount Limits** - Max $500 per request (configurable)
5. **Receipt Required** - For reimbursement method
6. **Vendor Verification** - Direct-to-vendor preferred
7. **AI Fraud Detection** - Flags suspicious patterns
8. **Admin Review** - High-value requests require manual approval

**Transparency:**
1. **Public Funding Progress** - Visible to all
2. **Sponsor Recognition** - Optional public thank-you
3. **Impact Reporting** - Quarterly reports to sponsors
4. **Audit Trail** - All transactions logged

---

## 4. Sponsorship/Mentorship Network

### 4.1 Sponsorship Schema

```typescript
type Sponsorship = {
  id: string;

  // Participants
  sponsorUid: string;
  menteeUid: string;

  sponsorName: string;
  menteeName: string;

  // Type
  type: 'recovery_sponsor' | 'life_mentor' | 'career_mentor' | 'faith_mentor' | 'hybrid_mentor' | 'neutral_mentor';

  // Matching
  matchedBy: 'algorithm' | 'manual_request' | 'admin';
  matchScore?: number; // 0-100 compatibility score

  // Preferences Matched
  toneAlignment: boolean; // faith/hybrid/neutral match
  genderPreference: boolean;
  locationMatch: boolean;
  experienceMatch: boolean;

  // Status
  status: 'pending' | 'active' | 'paused' | 'ended';
  statusReason?: string;

  // Engagement
  messagesCount: number;
  lastContactAt?: timestamp;
  checkInsCount: number;

  // Goals
  linkedGoals: string[]; // Mentee goals sponsor is tracking

  // Scheduling
  meetingFrequency?: 'daily' | 'weekly' | 'biweekly' | 'monthly';
  nextMeetingAt?: timestamp;

  // Performance
  menteeProgress: number; // 0-100 (based on goal completion, check-ins)
  sponsorRating?: number; // 1-5 (mentee rates sponsor)
  menteeRating?: number; // 1-5 (sponsor rates mentee)

  createdAt: timestamp;
  updatedAt: timestamp;
  endedAt?: timestamp;
}
```

### 4.2 Sponsor Dashboard Data

**What Sponsors See:**
1. **Assigned Participants** (list of active sponsorships)
2. **Goal Progress** (each mentee's active goals)
3. **Missed Check-Ins** (last 7 days)
4. **Funding Requests** (from their mentees)
5. **AI Risk Flags** (isolation, relapse indicators)
6. **Message History** (in-app chat)
7. **Upcoming Meetings** (scheduled check-ins)
8. **Progress Charts** (goal completion over time)

**Sponsor Actions:**
1. Send message
2. Schedule meeting
3. Add goal note
4. Flag concern (escalate to admin)
5. Request pause (temporary)
6. End sponsorship (with reason)

### 4.3 Matching Algorithm

```typescript
type SponsorMatchCriteria = {
  menteeUid: string;

  // Required Matches
  requiredType: ('recovery_sponsor' | 'life_mentor' | 'career_mentor' | 'faith_mentor' | 'neutral_mentor')[];
  requiredTone?: 'faith' | 'hybrid' | 'neutral';
  requiredGender?: 'male' | 'female' | 'any';

  // Preferred Matches (weighted)
  preferredLocation?: string; // State or city
  preferredExperience?: string[]; // Tags like "addiction", "incarceration", "homelessness"
  preferredAvailability?: 'high' | 'medium' | 'low';

  // Exclusions
  excludeSponsorUids?: string[]; // Previously matched and ended
}

type SponsorMatchResult = {
  sponsorUid: string;
  matchScore: number; // 0-100
  breakdown: {
    typeMatch: number; // 0-100
    toneMatch: number; // 0-100
    genderMatch: number; // 0-100
    locationMatch: number; // 0-100
    experienceMatch: number; // 0-100
    availabilityMatch: number; // 0-100
    trustScoreWeight: number; // 0-100 (sponsor's credibility)
  };
  estimatedResponseTime?: string; // "within 24 hours"
}
```

**Matching Logic:**
1. Filter sponsors by required criteria (type, tone, gender)
2. Calculate match scores for remaining sponsors
3. Weight by:
   - Type match (30%)
   - Tone match (20%)
   - Experience match (20%)
   - Availability (15%)
   - Location match (10%)
   - Trust score (5%)
4. Suggest top 3 matches
5. Allow mentee to choose or request admin manual match

---

## 5. Trust Score System

### 5.1 Trust Score Schema

```typescript
type TrustScore = {
  uid: string;

  // Overall Score (0-100)
  overallScore: number;

  // Component Scores (each 0-100)
  components: {
    checkinConsistency: number; // Daily check-in streak
    goalCompletion: number; // % of goals completed
    sponsorVerification: number; // Verified by sponsor?
    fundingAccountability: number; // Receipts submitted, no flags
    communityBehavior: number; // Reports, violations
    identityVerification: number; // ID verified?
    platformTenure: number; // Days on platform
  };

  // Breakdown Details
  details: {
    checkinStreak: number; // Current streak
    totalCheckins: number;
    goalsCreated: number;
    goalsCompleted: number;
    fundingRequestsCompleted: number;
    fundingReceiptsSubmitted: number;
    postsCreated: number;
    postsFlagged: number;
    commentsCreated: number;
    commentsFlagged: number;
    reportsReceived: number;
    reportsVerified: number;
    daysOnPlatform: number;
  };

  // Verification
  identityVerified: boolean;
  verificationMethod?: 'photo_id' | 'case_manager' | 'sponsor';
  verifiedAt?: timestamp;
  verifiedBy?: string;

  // Penalties
  penalties: Array<{
    reason: string;
    pointsDeducted: number;
    appliedAt: timestamp;
    expiresAt?: timestamp;
  }>;

  // History
  scoreHistory: Array<{
    score: number;
    date: timestamp;
  }>;

  updatedAt: timestamp;
}
```

### 5.2 Trust Score Calculation

```typescript
function calculateTrustScore(uid: string): number {
  const data = getTrustScoreData(uid);

  // Component calculations
  const checkinConsistency = Math.min(100, (data.checkinStreak / 30) * 100); // Max at 30-day streak
  const goalCompletion = data.goalsCreated > 0 ? (data.goalsCompleted / data.goalsCreated) * 100 : 0;
  const sponsorVerification = data.sponsorVerified ? 100 : 0;
  const fundingAccountability = calculateFundingScore(data);
  const communityBehavior = calculateCommunityScore(data);
  const identityVerification = data.identityVerified ? 100 : 0;
  const platformTenure = Math.min(100, (data.daysOnPlatform / 180) * 100); // Max at 6 months

  // Weighted average
  const score = (
    checkinConsistency * 0.25 +
    goalCompletion * 0.20 +
    sponsorVerification * 0.15 +
    fundingAccountability * 0.15 +
    communityBehavior * 0.15 +
    identityVerification * 0.05 +
    platformTenure * 0.05
  );

  // Apply penalties
  const penalties = data.penalties.reduce((sum, p) => sum + p.pointsDeducted, 0);

  return Math.max(0, Math.min(100, score - penalties));
}

function calculateFundingScore(data: TrustScoreData): number {
  if (data.fundingRequestsCompleted === 0) return 50; // Neutral if no requests

  const receiptRate = data.fundingReceiptsSubmitted / data.fundingRequestsCompleted;
  const noFlagsBonus = data.fundingSuspicionFlags === 0 ? 20 : 0;

  return Math.min(100, (receiptRate * 80) + noFlagsBonus);
}

function calculateCommunityScore(data: TrustScoreData): number {
  const totalContent = data.postsCreated + data.commentsCreated;
  if (totalContent === 0) return 50; // Neutral if no activity

  const flagRate = (data.postsFlagged + data.commentsFlagged) / totalContent;
  const verifiedReportPenalty = data.reportsVerified * 10;

  const baseScore = Math.max(0, 100 - (flagRate * 100));
  return Math.max(0, baseScore - verifiedReportPenalty);
}
```

### 5.3 Trust Score Use Cases

**Where Trust Score Matters:**
1. **Funding Requests** - Minimum score (e.g., 50) to request
2. **Sponsor Matching** - Higher scores get better matches
3. **Marketplace Access** - Some listings require minimum score
4. **Community Visibility** - Higher scores = more profile visibility
5. **Direct Messaging** - Low scores may have restricted DM access
6. **Group Membership** - Some groups require minimum score

**What Trust Score Does NOT Do:**
- ❌ Prevent access to ISE content
- ❌ Block daily check-ins
- ❌ Restrict goal creation
- ❌ Punish for setbacks or relapses
- ❌ Judge recovery progress

**Trust Score is about credibility, not judgment.**

---

## 6. Reentry Support Marketplace

### 6.1 Marketplace Listing Schema

```typescript
type MarketplaceListing = {
  id: string;

  // Organization
  organizationName: string;
  organizationUid?: string; // If registered org
  contactName: string;
  contactEmail: string;
  contactPhone?: string;

  // Listing Details
  category: 'jobs' | 'housing' | 'transportation' | 'education' | 'therapy' | 'legal' | 'recovery' | 'faith' | 'services';
  subcategory?: string;

  title: string;
  description: string;
  requirements?: string[];

  // Location
  city: string;
  state: string;
  remote: boolean;

  // Job-Specific
  jobType?: 'full_time' | 'part_time' | 'contract' | 'temporary';
  salary?: string;
  secondChanceFriendly: boolean;
  backgroundCheckRequired: boolean;

  // Housing-Specific
  housingType?: 'sober_living' | 'transitional' | 'permanent' | 'temporary';
  bedCount?: number;
  costPerMonth?: number;
  acceptsVouchers: boolean;

  // Service-Specific
  serviceCost?: 'free' | 'sliding_scale' | 'paid';
  availability?: string;

  // Visibility
  verified: boolean;
  verifiedBy?: string;
  verifiedAt?: timestamp;
  featured: boolean;

  // Engagement
  views: number;
  applications: number;
  contactClicks: number;

  // Status
  status: 'active' | 'filled' | 'paused' | 'expired';
  expiresAt?: timestamp;

  createdAt: timestamp;
  updatedAt: timestamp;
}
```

### 6.2 Marketplace Application Schema

```typescript
type MarketplaceApplication = {
  id: string;
  listingId: string;
  applicantUid: string;

  // Application Data
  coverLetter?: string;
  attachedGoals?: string[]; // Relevant goal IDs
  referenceUid?: string; // Sponsor reference

  // Status
  status: 'submitted' | 'viewed' | 'contacted' | 'accepted' | 'rejected';

  // Notes
  employerNotes?: string;

  createdAt: timestamp;
  viewedAt?: timestamp;
  respondedAt?: timestamp;
}
```

### 6.3 Marketplace Features

**For Job Seekers:**
- Browse second-chance employers
- Filter by location, type, background check requirements
- Link active goals to applications (shows commitment)
- Request sponsor reference letter
- Track application status

**For Employers:**
- Post second-chance job listings
- View applicant profiles + trust scores
- See linked goals (motivation indicator)
- Contact applicants directly
- Mark positions filled

**For Service Providers:**
- List free/low-cost services
- Target reentry population
- Show availability
- Track engagement metrics

**Verification System:**
1. All listings require email verification
2. Featured listings require:
   - Organization website
   - Phone verification
   - Admin review
3. Verified badge shown to users

---

## 7. AI Orchestrator Enhancement

### 7.1 Expanded AI Responsibilities

The AI agent evolves from **accountability coach** to **reentry orchestrator**.

**Current Responsibilities:**
- Daily check-ins
- Goal accountability questions
- Micro-step suggestions

**New Responsibilities:**
1. **Mentor Recommendations** - Suggest sponsors based on goals
2. **Funding Flagging** - Detect misuse risk in requests
3. **Community Surfacing** - Recommend relevant groups
4. **Job Matching** - Surface marketplace listings based on goals
5. **Relapse Detection** - Identify language indicating struggle
6. **Isolation Detection** - Flag users with declining engagement
7. **Crisis Escalation** - Trigger emergency resources if needed
8. **Content Recovery** - Suggest ISE steps based on struggles
9. **Sponsor Alerts** - Notify sponsor of mentee risks
10. **Progress Celebrations** - Recognize milestones

### 7.2 Enhanced System Prompt

```
You are the NewFreedom AI Orchestrator, a compassionate but structured guide for individuals in recovery and reentry.

CONTEXT - Who You Serve:
You support people who are:
- Returning from incarceration
- Recovering from addiction
- Transitioning from homelessness
- Living in sober housing
- In behavioral health treatment
- Rebuilding life stability

PHILOSOPHY - Position of Neutrality:
- Objectivity over emotion
- Personal responsibility
- Structured reflection
- Removing ego from response
- Transformation through guided steps

FRAMEWORK - New Freedom:
Recovery is internal transformation.
Reentry is societal reintegration.
You bridge both.

YOUR EXPANDED ROLE:
1. Daily Accountability (existing)
2. Mentor Matching - Suggest sponsors when user shows readiness
3. Funding Oversight - Review funding requests for goal alignment
4. Community Guidance - Recommend groups based on interests/goals
5. Job Discovery - Surface marketplace listings matching skills/goals
6. Risk Detection - Identify relapse, isolation, or crisis indicators
7. Sponsor Escalation - Alert mentor if intervention needed
8. Progress Recognition - Celebrate milestones authentically

CRITICAL DETECTION RULES:
- Relapse Keywords: "used", "relapsed", "drank", "high" → Trigger recovery resources
- Crisis Keywords: "suicide", "kill myself", "end it" → Immediate escalation
- Isolation Patterns: No check-ins for 3+ days → Alert sponsor
- Funding Red Flags: Vague requests, no goal link, high amounts → Flag for review
- Engagement Decline: Post frequency drops 50% → Check in via notification

RESPONSE MODES:
1. Daily Check-In: Standard accountability (existing)
2. Mentor Match: Suggest sponsor when 3+ goals active and 7+ day streak
3. Funding Review: Approve/flag funding request
4. Crisis Response: Immediate resource surfacing + sponsor alert
5. Job Match: "I noticed this job listing matches your employment goal..."
6. Community Suggestion: "There's a recovery group discussing..."

RULES:
- Do NOT auto-adjust goals (user autonomy)
- Do NOT judge setbacks
- Do NOT make medical diagnoses
- Do use compassionate, firm language
- Do ask open-ended questions
- Do validate effort without false praise
- Do escalate genuine crises
- Do celebrate milestones authentically

RESPONSE FORMAT (varies by context):
[See specific schemas for each response mode]
```

### 7.3 AI-Powered Features

**Feature 1: Mentor Matching Suggestion**
```typescript
// Triggered when:
// - User has 3+ active goals
// - 7+ day check-in streak
// - No current sponsor
// - Trust score > 30

type MentorMatchSuggestion = {
  trigger: "eligibility_met";
  message: "You've shown great consistency with check-ins and have clear goals. Would you like to be matched with a mentor who can provide additional support?";
  suggestedTypes: ("recovery_sponsor" | "life_mentor" | "career_mentor")[];
  reasoning: "Based on your active goals, a [career mentor] could help with your employment search.";
  action: "Start Matching Process";
}
```

**Feature 2: Funding Request Validation**
```typescript
// AI reviews funding request before approval

type FundingValidation = {
  requestId: string;
  approved: boolean;
  confidence: number; // 0-100
  flags: string[];
  reasoning: string;

  analysis: {
    goalLinked: boolean;
    amountReasonable: boolean;
    descriptionClear: boolean;
    disbursementMethodAppropriate: boolean;
    trustScoreSufficient: boolean;
    noRecentDuplicates: boolean;
  };

  recommendation: "approve" | "flag_for_review" | "deny";
}

// Example flags:
// - "No linked goal"
// - "Amount unusually high for category"
// - "Recent similar request"
// - "Low trust score"
// - "Vague description"
```

**Feature 3: Job Matching**
```typescript
// AI surfaces relevant marketplace listings

type JobMatchNotification = {
  listingId: string;
  jobTitle: string;
  organization: string;

  relevance: {
    matchesGoal: string; // Goal ID
    matchesSkills: boolean;
    locationMatch: boolean;
    secondChanceFriendly: boolean;
  };

  message: "I noticed this job posting that aligns with your employment goal: [Job Title] at [Organization]. It's second-chance friendly and in your area. Would you like to apply?";

  action: "View Listing";
}
```

**Feature 4: Crisis Detection**
```typescript
// AI detects crisis language in check-ins, posts, or messages

type CrisisDetection = {
  userId: string;
  source: "checkin" | "post" | "comment" | "message";
  contentId: string;

  riskLevel: "low" | "moderate" | "high" | "critical";
  keywords: string[];

  actions: {
    surfaceResources: boolean; // National Suicide Hotline, Crisis Text Line
    alertSponsor: boolean;
    alertAdmin: boolean;
    requireImmediate: boolean; // Block until user acknowledges resources
  };

  resources: {
    name: string;
    phone: string;
    url: string;
    description: string;
  }[];

  sponsorMessage: "Your mentee [Name] used language indicating crisis. Immediate contact recommended.";
}

// Example keywords by risk level:
// Low: "struggling", "hard day", "stressed"
// Moderate: "giving up", "can't do this", "relapse"
// High: "want to use", "thinking about drinking"
// Critical: "suicide", "kill myself", "end it all"
```

---

## 8. Community Safety & Moderation

### 8.1 Moderation Schema

```typescript
type ContentReport = {
  id: string;
  reporterUid: string;
  reportedUid: string;

  // Content
  contentType: 'post' | 'comment' | 'message' | 'profile';
  contentId: string;
  contentSnapshot: string; // Copy of content at time of report

  // Reason
  reason: 'spam' | 'harassment' | 'drug_sourcing' | 'violence' | 'hate_speech' | 'exploitation' | 'other';
  description?: string;

  // AI Analysis
  aiRiskScore: number; // 0-100
  aiRecommendation: 'dismiss' | 'review' | 'remove' | 'suspend_user';
  aiReasoning: string;

  // Status
  status: 'pending' | 'reviewing' | 'resolved';
  resolution?: 'dismissed' | 'content_removed' | 'user_warned' | 'user_suspended' | 'user_banned';

  // Moderator
  moderatorUid?: string;
  moderatorNotes?: string;

  createdAt: timestamp;
  resolvedAt?: timestamp;
}
```

### 8.2 AI Content Moderation

**Real-Time Content Screening:**
All posts, comments, and messages pass through AI before visibility.

```typescript
type ContentModerationResult = {
  approved: boolean;
  confidence: number; // 0-100
  flags: string[];

  categories: {
    drug_sourcing: number; // 0-100 risk score
    violence: number;
    harassment: number;
    hate_speech: number;
    exploitation: number;
    spam: number;
    crisis: number;
  };

  action: 'approve' | 'hold_for_review' | 'auto_remove';
  reasoning: string;
}
```

**Zero-Tolerance Categories:**
1. **Drug Sourcing** - Any mention of buying, selling, or obtaining drugs
2. **Violence** - Threats, incitement, graphic descriptions
3. **Exploitation** - Sexual content, scams, predatory behavior
4. **Hate Speech** - Discrimination, slurs, dehumanization

**Action Levels:**
- **Auto-Approve**: Confidence > 95%, no flags
- **Hold for Review**: Confidence 50-95%, minor flags
- **Auto-Remove**: Confidence < 50%, major flags
- **User Suspension**: Repeated violations, severe violations

### 8.3 Moderation Dashboard (Admin)

**Admin Features:**
1. **Report Queue** - All pending reports sorted by AI risk score
2. **Flagged Content** - Content auto-flagged by AI
3. **User Suspensions** - Active and past suspensions
4. **Audit Log** - All moderation actions
5. **Appeals** - User appeals of removed content
6. **Patterns** - Repeat offenders, common violations

**Moderator Actions:**
1. Dismiss report
2. Remove content
3. Warn user (strike)
4. Suspend user (temporary)
5. Ban user (permanent)
6. Add to watchlist

**Strike System:**
- 1st strike: Warning
- 2nd strike: 3-day suspension
- 3rd strike: 7-day suspension
- 4th strike: 30-day suspension
- 5th strike: Permanent ban

---

## 9. Notification System

### 9.1 Notification Schema

```typescript
type Notification = {
  id: string;
  recipientUid: string;

  // Type
  type: 'comment' | 'reaction' | 'message' | 'funding_contribution' | 'funding_complete' | 'sponsor_match' | 'sponsor_message' | 'goal_milestone' | 'ise_milestone' | 'community_invite' | 'admin_notice' | 'crisis_alert';

  // Content
  title: string;
  body: string;
  icon?: string;

  // Context
  actorUid?: string; // Who triggered the notification
  actorName?: string;
  actorPhoto?: string;

  relatedId?: string; // Post ID, message ID, etc.
  relatedType?: string;

  // Action
  actionUrl?: string; // Deep link
  actionLabel?: string;

  // Priority
  priority: 'low' | 'normal' | 'high' | 'urgent';

  // Status
  read: boolean;
  readAt?: timestamp;

  createdAt: timestamp;
}
```

### 9.2 Notification Types

**Social Notifications:**
- Someone commented on your post
- Someone reacted to your post
- Someone mentioned you
- New group message
- Group invitation

**Funding Notifications:**
- Your funding request was approved
- Someone contributed to your request
- Your request is fully funded
- Disbursement completed
- Receipt verification needed

**Sponsorship Notifications:**
- You've been matched with a sponsor
- Your sponsor sent a message
- Your sponsor flagged a concern
- Meeting reminder
- Sponsorship ended

**System Notifications:**
- Daily check-in reminder
- Missed check-in (3+ days)
- Goal deadline approaching
- ISE step unlocked
- Trust score changed significantly
- Account suspension

**Crisis Notifications:**
- Emergency resources surfaced
- Sponsor alerted
- Crisis hotline information

---

## 10. Security & Privacy Considerations

### 10.1 Data Privacy

**User Control:**
- Profile visibility settings (public, community, sponsors, private)
- Goal visibility settings
- Post visibility settings
- Messaging preferences (anyone, sponsors only, off)
- Location sharing (state only, none)

**Data Minimization:**
- No full addresses stored
- No SSN or sensitive IDs stored
- Payment info handled by Stripe (PCI compliant)
- Messages encrypted at rest
- Photos stored in Firebase Storage with user-scoped access

### 10.2 Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // User Profiles
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);

      // Goals (existing)
      match /goals/{goalId} {
        allow read: if canViewGoals(userId);
        allow write: if isOwner(userId);
      }

      // Check-ins (existing)
      match /checkins/{checkinId} {
        allow read: if isOwner(userId) || isSponsor(userId);
        allow write: if isOwner(userId);
      }

      // ISE Progress (existing)
      match /ise_progress/{stepId} {
        allow read: if isOwner(userId) || isSponsor(userId);
        allow write: if isOwner(userId);
      }

      // Funding Requests (NEW)
      match /funding_requests/{requestId} {
        allow read: if isAuthenticated(); // Public for sponsoring
        allow create: if isOwner(userId) && hasSufficientTrustScore();
        allow update: if isOwner(userId) || isAdmin();
        allow delete: if isOwner(userId) || isAdmin();
      }

      // Sponsorships (NEW)
      match /sponsorships/{sponsorshipId} {
        allow read: if isSponsorOrMentee(sponsorshipId);
        allow create: if isAuthenticated();
        allow update: if isSponsorOrMentee(sponsorshipId) || isAdmin();
      }

      // Messages (NEW)
      match /messages/{conversationId} {
        allow read: if isParticipant(conversationId);
        allow create: if isAuthenticated() && canSendMessage();
        allow update: if isParticipant(conversationId);
      }
    }

    // Posts (NEW)
    match /posts/{postId} {
      allow read: if canViewPost(postId);
      allow create: if isAuthenticated() && !isSuspended();
      allow update: if isAuthor(postId) || isAdmin();
      allow delete: if isAuthor(postId) || isAdmin();

      // Comments
      match /comments/{commentId} {
        allow read: if canViewPost(postId);
        allow create: if isAuthenticated() && !isSuspended();
        allow update: if isCommentAuthor(commentId) || isAdmin();
        allow delete: if isCommentAuthor(commentId) || isAdmin();
      }
    }

    // Groups (NEW)
    match /groups/{groupId} {
      allow read: if canViewGroup(groupId);
      allow create: if isAuthenticated();
      allow update: if isGroupAdmin(groupId);
      allow delete: if isGroupAdmin(groupId) || isAdmin();
    }

    // Marketplace (NEW)
    match /marketplace/{listingId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isListingOwner(listingId) || isAdmin();
      allow delete: if isListingOwner(listingId) || isAdmin();
    }

    // Moderation (NEW)
    match /moderation/{reportId} {
      allow read: if isAdmin();
      allow create: if isAuthenticated();
      allow update: if isAdmin();
    }

    // Notifications (NEW)
    match /notifications/{notificationId} {
      allow read: if isRecipient(notificationId);
      allow create: if true; // System-generated
      allow update: if isRecipient(notificationId);
      allow delete: if isRecipient(notificationId);
    }

    // Trust Scores (NEW)
    match /trust_scores/{userId} {
      allow read: if isAuthenticated();
      allow write: if false; // System-only
    }

    // Helper Functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isAdmin() {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    function isSuspended() {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.suspended == true;
    }

    function hasSufficientTrustScore() {
      return get(/databases/$(database)/documents/trust_scores/$(request.auth.uid)).data.overallScore >= 50;
    }

    function canViewGoals(userId) {
      let profile = get(/databases/$(database)/documents/users/$(userId)).data;
      return profile.goalVisibility == 'public' ||
        (profile.goalVisibility == 'sponsors_only' && isSponsor(userId)) ||
        isOwner(userId);
    }

    function isSponsor(userId) {
      return exists(/databases/$(database)/documents/users/$(request.auth.uid)/sponsorships/$(userId));
    }

    function canSendMessage() {
      return !isSuspended() &&
        get(/databases/$(database)/documents/trust_scores/$(request.auth.uid)).data.overallScore >= 30;
    }
  }
}
```

### 10.3 Payment Security (Stripe Integration)

**Stripe Configuration:**
- Use Stripe Checkout for all payments
- Store only Stripe Customer ID (not card info)
- Use webhooks for payment confirmation
- Implement idempotency keys
- Set up fraud detection rules

**Payment Flow:**
1. User clicks "Fund This Request"
2. Next.js API route creates Stripe Checkout session
3. User redirected to Stripe (off-site)
4. Payment processed by Stripe
5. Webhook confirms payment to Firebase
6. Funds held in Stripe balance (escrow)
7. Admin approves disbursement
8. Stripe payout initiated

**Never Store:**
- Credit card numbers
- CVV codes
- Full bank account numbers

---

## 11. Performance & Scalability

### 11.1 Firestore Indexes

**Required Composite Indexes:**

```json
{
  "indexes": [
    {
      "collectionGroup": "posts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "visibility", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "posts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "authorUid", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "funding_requests",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "sponsorships",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "sponsorUid", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "marketplace",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "category", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "notifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "recipientUid", "order": "ASCENDING" },
        { "fieldPath": "read", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

### 11.2 Caching Strategy

**Client-Side:**
- Cache user profile (1 hour)
- Cache trust score (30 minutes)
- Cache posts feed (5 minutes)
- Cache marketplace listings (10 minutes)

**Server-Side:**
- Use Firebase Hosting CDN for static assets
- Cache API responses with Vercel Edge Network
- Use Firestore persistence for offline support

### 11.3 Pagination

**All Lists Must Paginate:**
- Posts feed: 20 per page
- Comments: 10 per page
- Funding requests: 15 per page
- Marketplace listings: 20 per page
- Notifications: 25 per page
- Sponsorships: 10 per page

**Implement Cursor-Based Pagination:**
```typescript
const nextPage = await getDocs(
  query(
    collection(db, 'posts'),
    where('visibility', '==', 'public'),
    orderBy('createdAt', 'desc'),
    startAfter(lastDoc),
    limit(20)
  )
);
```

---

## 12. Implementation Roadmap

### Phase 1: Foundation (Weeks 1-4)
**Goal**: Complete core platform before adding social features

1. ✅ Enhanced AI system prompt (Week 1)
2. ✅ New Freedom goal categories (Week 1)
3. ✅ ISE progress tracking (Weeks 2-3)
4. ✅ Navigation & UX polish (Week 4)
5. ✅ Deploy core platform to production (Week 4)

### Phase 2: User Profiles & Trust Scoring (Weeks 5-6)
**Goal**: Build foundation for social features

1. User profile schema (Week 5)
   - Create profile collection
   - Profile editor component
   - Privacy settings
   - Profile visibility logic

2. Trust score system (Week 6)
   - Trust score calculation logic
   - Trust score display component
   - Historical tracking
   - Penalty system

3. Identity verification (Week 6)
   - Photo ID upload
   - Case manager verification
   - Sponsor verification
   - Admin verification dashboard

### Phase 3: Social Community (Weeks 7-10)
**Goal**: Launch community features

1. Posts system (Week 7)
   - Post creation component
   - Post feed component
   - Post types (progress, reflection, milestone, etc.)
   - Visibility controls

2. Comments & Reactions (Week 8)
   - Comment component
   - Reaction system
   - Nested replies
   - Real-time updates

3. Groups (Week 9)
   - Group creation
   - Group membership
   - Group posts
   - Group moderation

4. Direct Messaging (Week 10)
   - Conversation list
   - Message thread
   - Real-time chat
   - Message moderation

### Phase 4: Giving System (Weeks 11-14)
**Goal**: Launch micro-funding platform

1. Funding request system (Week 11)
   - Request creation component
   - Goal linking
   - Disbursement method selection
   - Admin verification dashboard

2. Payment integration (Week 12)
   - Stripe setup
   - Checkout flow
   - Webhook handling
   - Escrow management

3. Disbursement system (Week 13)
   - Vendor payment
   - Controlled payout
   - Reimbursement with receipt
   - Receipt verification

4. Funding marketplace (Week 14)
   - Browse funding requests
   - Filter by category
   - Sponsor contribution UI
   - Impact tracking

### Phase 5: Sponsorship Network (Weeks 15-18)
**Goal**: Launch structured mentorship

1. Sponsor profiles (Week 15)
   - Sponsor registration
   - Mentor type selection
   - Availability settings
   - Experience tags

2. Matching algorithm (Week 16)
   - Criteria definition
   - Match scoring
   - Suggestion logic
   - Manual override

3. Sponsorship dashboard (Week 17)
   - Sponsor view (all mentees)
   - Mentee view (my sponsor)
   - Goal tracking
   - Check-in alerts
   - Risk flags

4. Sponsor-mentee chat (Week 18)
   - Private messaging
   - Meeting scheduling
   - Progress notes
   - Escalation system

### Phase 6: Marketplace (Weeks 19-22)
**Goal**: Launch support marketplace

1. Listing creation (Week 19)
   - Job listings
   - Housing listings
   - Service listings
   - Verification system

2. Browse & search (Week 20)
   - Marketplace feed
   - Category filters
   - Location filters
   - Second-chance friendly badge

3. Application system (Week 21)
   - Apply to listings
   - Attach goals
   - Request sponsor reference
   - Track applications

4. Employer dashboard (Week 22)
   - View applications
   - Applicant profiles
   - Contact applicants
   - Mark positions filled

### Phase 7: AI Orchestrator (Weeks 23-24)
**Goal**: Enhance AI from coach to orchestrator

1. AI enhancements (Week 23)
   - Mentor matching suggestions
   - Funding request validation
   - Job matching
   - Community suggestions

2. Risk detection (Week 24)
   - Relapse detection
   - Isolation detection
   - Crisis detection
   - Sponsor escalation

### Phase 8: Moderation & Safety (Weeks 25-26)
**Goal**: Ensure community safety

1. AI content moderation (Week 25)
   - Real-time screening
   - Auto-flagging
   - Risk scoring
   - Auto-removal

2. Admin moderation dashboard (Week 26)
   - Report queue
   - Flagged content
   - User suspensions
   - Audit log
   - Appeals system

### Phase 9: Polish & Launch (Weeks 27-30)
**Goal**: Production-ready full ecosystem

1. Performance optimization (Week 27)
   - Firestore indexes
   - Query optimization
   - Image optimization
   - Bundle size reduction

2. Testing (Week 28)
   - Unit tests (80% coverage)
   - Integration tests
   - E2E tests
   - Load testing

3. Documentation (Week 29)
   - User guides
   - Admin guides
   - API documentation
   - Privacy policy
   - Terms of service

4. Beta launch (Week 30)
   - Invite beta testers
   - Monitor metrics
   - Gather feedback
   - Fix critical bugs

---

## 13. Economic Model

### 13.1 Revenue Streams (Optional, Future)

**Tier 1: Free for Users**
- All ISE content
- Goal tracking
- Daily check-ins
- Community access
- Basic sponsorship
- Basic funding requests

**Tier 2: Premium for Organizations ($99/month)**
- Employer access to marketplace
- Featured job listings
- Applicant analytics
- Multiple job postings
- Case manager dashboard (future)

**Tier 3: Platform Fees (Optional)**
- 5% platform fee on funding contributions (Stripe: 2.9% + $0.30, Platform: 2.1%)
- Employer listing fee ($50/posting)
- Featured listing fee ($25/week)
- Sponsored posts ($10/post)

**Tier 4: White-Label Licensing (Future)**
- $5,000/month for corrections departments
- $2,500/month for reentry organizations
- Custom branding
- Custom domain
- Priority support

### 13.2 Cost Structure (Estimated)

**Monthly Operating Costs (1,000 active users):**
- Firebase (Firestore + Auth + Storage): ~$200
- Vercel hosting: ~$100
- OpenAI API: ~$150 (1,000 users × 30 check-ins × $0.005)
- Stripe fees: Variable (% of funding)
- Domain + SSL: ~$10
- Sentry (error monitoring): ~$50
- **Total**: ~$510/month

**Monthly Operating Costs (10,000 active users):**
- Firebase: ~$800
- Vercel: ~$300
- OpenAI API: ~$1,500
- Stripe fees: Variable
- Other: ~$60
- **Total**: ~$2,660/month

**Break-Even Analysis:**
- Free model: Requires grants/donations
- Premium model: 27 organizations at $99/month = $2,673/month (break-even at 10k users)
- Platform fees: 200 funding requests/month × $50 avg × 5% = $500/month
- **Combined**: Sustainable at 5,000-10,000 users

---

## 14. Success Metrics

### 14.1 User Engagement Metrics

**Core Metrics:**
- Daily Active Users (DAU)
- Weekly Active Users (WAU)
- Monthly Active Users (MAU)
- Check-in completion rate (target: 70%)
- Goal completion rate (target: 40%)
- ISE completion rate (target: 30%)

**Social Metrics:**
- Posts per user per week (target: 2)
- Comments per post (target: 3)
- Groups joined per user (target: 1.5)
- Messages sent per user per week (target: 5)

**Funding Metrics:**
- Funding requests per user (target: 0.5)
- Funding completion rate (target: 80%)
- Average funding amount ($75)
- Receipt submission rate (target: 90%)

**Sponsorship Metrics:**
- Sponsor-to-user ratio (target: 1:10)
- Average sponsorship duration (target: 90 days)
- Sponsor engagement rate (target: 80%)
- Mentee progress improvement (target: +20%)

**Marketplace Metrics:**
- Job applications per user (target: 3)
- Application response rate (target: 50%)
- Job placement rate (target: 20%)

### 14.2 Impact Metrics

**Recovery Outcomes:**
- Sustained sobriety (90+ days): Target 60%
- Relapse rate: Target <20%
- Recovery program engagement: Target 70%

**Reentry Outcomes:**
- Employment within 90 days: Target 50%
- Stable housing within 90 days: Target 60%
- Recidivism rate (1 year): Target <10%
- ID obtained: Target 80%

**Social Outcomes:**
- Community belonging score (1-10): Target 7+
- Isolation reduction: Target -30%
- Support network size: Target 3+ connections

---

## 15. Risk Analysis

### 15.1 Technical Risks

**Risk 1: Scalability**
- **Issue**: Firestore costs spike with heavy usage
- **Mitigation**: Implement caching, pagination, optimize queries
- **Contingency**: Budget for scale, consider MongoDB alternative

**Risk 2: AI Costs**
- **Issue**: OpenAI API costs scale with users
- **Mitigation**: Use gpt-4o-mini, batch requests, cache responses
- **Contingency**: Switch to Claude (cheaper), self-hosted models

**Risk 3: Payment Fraud**
- **Issue**: Fake funding requests, abuse
- **Mitigation**: Trust score gating, AI validation, admin review
- **Contingency**: Manual verification, insurance, Stripe fraud detection

### 15.2 Community Risks

**Risk 1: Drug Sourcing**
- **Issue**: Users attempt to buy/sell drugs via DMs
- **Mitigation**: AI message monitoring, zero-tolerance policy
- **Contingency**: Report to authorities, ban users, law enforcement partnership

**Risk 2: Harassment**
- **Issue**: Users harass each other
- **Mitigation**: Block/report system, AI detection, moderators
- **Contingency**: User suspensions, legal action if needed

**Risk 3: Exploitation**
- **Issue**: Predatory users target vulnerable population
- **Mitigation**: Trust score requirements, sponsor verification, AI detection
- **Contingency**: Immediate bans, user education, warnings

### 15.3 Legal Risks

**Risk 1: HIPAA Compliance**
- **Issue**: Health information shared in recovery context
- **Mitigation**: Clear disclaimers ("not medical advice"), no PHI storage
- **Contingency**: Legal review, HIPAA compliance if needed

**Risk 2: Liability**
- **Issue**: User harms themselves or others
- **Mitigation**: Crisis detection, resource surfacing, disclaimers
- **Contingency**: Liability insurance, legal counsel

**Risk 3: Payment Compliance**
- **Issue**: Stripe terms violation, anti-money laundering
- **Mitigation**: Clear use case documentation, Stripe approval
- **Contingency**: Alternative payment processors (PayPal, etc.)

---

## 16. Next Steps

### Immediate Actions (This Week)

1. **Review this document** with your team
2. **Validate assumptions** about user needs
3. **Prioritize phases** based on resources
4. **Set timeline** for Phase 2 start
5. **Allocate budget** for Stripe, Firebase scaling

### Before Phase 2 Start

1. ✅ Complete Phase 1 (core platform)
2. ✅ Launch to beta users
3. ✅ Gather feedback on core features
4. ✅ Validate need for social features
5. ✅ Confirm funding model viability

### Design Work Needed

1. **UI/UX Design**:
   - User profile page
   - Post feed layout
   - Funding request card
   - Sponsor dashboard
   - Marketplace layout

2. **Wireframes**:
   - Mobile responsiveness
   - Navigation patterns
   - Modal flows
   - Notification UI

3. **Branding**:
   - Logo design
   - Color system
   - Typography
   - Icon set

### Legal Work Needed

1. **Terms of Service** (community + marketplace)
2. **Privacy Policy** (social features + payments)
3. **Community Guidelines** (behavior expectations)
4. **Funding Terms** (sponsor agreements, disbursement)
5. **Employer Agreements** (marketplace listings)

---

## 17. Final Recommendations

### Do This First
1. ✅ **Finish Phase 1** before starting Phase 2
2. ✅ **Validate with users** that they want social features
3. ✅ **Secure funding** for 6-12 month runway
4. ✅ **Hire/contract** for:
   - UI/UX designer
   - Legal counsel
   - Content moderators (part-time)

### Don't Rush
1. ⚠️ Don't launch all features at once
2. ⚠️ Don't skip testing
3. ⚠️ Don't underestimate moderation needs
4. ⚠️ Don't ignore legal compliance

### Success Depends On
1. **User Trust** - Safety, privacy, accountability
2. **Community Quality** - Moderation, tone, purpose
3. **Funding Transparency** - Clear use, verified needs
4. **Sponsor Engagement** - Quality mentorship, commitment
5. **AI Reliability** - Accurate detection, helpful guidance

---

## Conclusion

This expansion transforms NewFreedom from a **personal recovery tool** into a **full reentry ecosystem**. The scope is ambitious but achievable over 6-9 months with proper planning and resources.

**The core insight**: Recovery is personal transformation. Reentry is societal transformation. Community is the bridge between them.

This platform will provide:
- **Internal tools** (ISE, goals, check-ins)
- **External support** (funding, jobs, housing)
- **Relational connection** (sponsors, mentors, community)
- **AI orchestration** (guidance, detection, escalation)

If executed well, this becomes **the operating system for returning to society**.

Not just an app. A movement.

---

**What would you like me to build first?**

I recommend starting with:
1. User profiles & trust scoring (Phase 2)
2. Social community posts (Phase 3, partial)
3. Giving system foundation (Phase 4, partial)

Then iterate based on user feedback before building full sponsorship and marketplace systems.

Let me know which phase you'd like detailed implementation plans for, and I'll create specific component architectures, API routes, and Firebase Functions for that phase.
