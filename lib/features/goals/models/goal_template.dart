import 'goal.dart';

class GoalTemplate {
  final String id;
  final String title;
  final String description;
  final GoalCategory category;
  final GoalType type;
  final List<String> milestones;
  final int? suggestedDurationDays;
  final String whyThis;

  const GoalTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.milestones,
    this.suggestedDurationDays,
    required this.whyThis,
  });
}

class GoalTemplates {
  static const List<GoalTemplate> recovery = [
    GoalTemplate(
      id: 'recovery_90_meetings',
      title: '90 Meetings in 90 Days',
      description:
          'Attend 90 recovery meetings in 90 days to build a strong foundation.',
      category: GoalCategory.recovery,
      type: GoalType.continuous,
      milestones: [
        '7 days (1 week)',
        '30 days (1 month)',
        '60 days (2 months)',
        '90 days (complete)',
      ],
      suggestedDurationDays: 90,
      whyThis:
          'Intensive meeting attendance builds community, accountability, and recovery momentum during early days.',
    ),
    GoalTemplate(
      id: 'recovery_complete_ise',
      title: 'Complete Interactive Step Experience',
      description: 'Work through all Position of Neutrality course videos.',
      category: GoalCategory.recovery,
      type: GoalType.milestone,
      milestones: [
        'Movement (Introduction)',
        'The Question (Foundation)',
        'Course 1: Concession',
        'Course 2: Encounter',
        'Course 3: Decision',
        'Course 4: Introspection',
        'Course 5: Repentance & Rededication',
        'Course 6: Spiritual Fitness',
      ],
      suggestedDurationDays: 60,
      whyThis:
          'The ISE provides a structured framework for internal recovery work and spiritual growth.',
    ),
    GoalTemplate(
      id: 'recovery_find_sponsor',
      title: 'Find a Sponsor',
      description: 'Connect with and commit to working with a sponsor.',
      category: GoalCategory.recovery,
      type: GoalType.milestone,
      milestones: [
        'Attend meetings to observe potential sponsors',
        'Ask someone to be my temporary sponsor',
        'Have initial conversation about expectations',
        'Commit to permanent sponsorship relationship',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'A sponsor provides guidance, accountability, and experience to navigate recovery.',
    ),
    GoalTemplate(
      id: 'recovery_daily_prayer',
      title: 'Establish Daily Prayer Routine',
      description: 'Build a consistent morning and evening prayer practice.',
      category: GoalCategory.recovery,
      type: GoalType.continuous,
      milestones: [
        '7 consecutive days',
        '14 consecutive days',
        '30 consecutive days',
        '90 consecutive days',
      ],
      suggestedDurationDays: 90,
      whyThis:
          'Daily prayer builds spiritual connection and provides strength for the recovery journey.',
    ),
    GoalTemplate(
      id: 'recovery_sobriety_milestone',
      title: 'Sobriety Milestone',
      description: 'Maintain continuous sobriety and celebrate milestones.',
      category: GoalCategory.recovery,
      type: GoalType.continuous,
      milestones: [
        '24 hours',
        '7 days',
        '30 days',
        '60 days',
        '90 days',
        '6 months',
        '1 year',
      ],
      whyThis:
          'Each day of sobriety is a victory worth celebrating and builds toward long-term recovery.',
    ),
  ];

  static const List<GoalTemplate> identityLegal = [
    GoalTemplate(
      id: 'identity_birth_certificate',
      title: 'Obtain Birth Certificate',
      description: 'Get certified copy of birth certificate.',
      category: GoalCategory.identityLegal,
      type: GoalType.milestone,
      milestones: [
        'Determine state of birth',
        'Find contact information for vital records office',
        'Gather required documentation',
        'Submit application and payment',
        'Receive birth certificate',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'A birth certificate is the foundation document needed for other IDs and legal documents.',
    ),
    GoalTemplate(
      id: 'identity_state_id',
      title: 'Get State ID or Driver\'s License',
      description: 'Obtain valid state-issued identification.',
      category: GoalCategory.identityLegal,
      type: GoalType.milestone,
      milestones: [
        'Gather required documents (birth certificate, proof of address)',
        'Schedule DMV appointment',
        'Pass written test (if applicable)',
        'Pass vision test',
        'Receive ID/license',
      ],
      suggestedDurationDays: 45,
      whyThis:
          'State ID is essential for employment, housing, banking, and accessing services.',
    ),
    GoalTemplate(
      id: 'identity_social_security',
      title: 'Get Social Security Card',
      description: 'Obtain or replace Social Security card.',
      category: GoalCategory.identityLegal,
      type: GoalType.milestone,
      milestones: [
        'Verify SSN through SSA records',
        'Gather required documents',
        'Visit local Social Security office',
        'Submit application',
        'Receive card in mail',
      ],
      suggestedDurationDays: 30,
      whyThis: 'SSN is required for employment and many government services.',
    ),
    GoalTemplate(
      id: 'identity_expunge_record',
      title: 'Research Record Expungement',
      description: 'Explore options for clearing or sealing criminal record.',
      category: GoalCategory.identityLegal,
      type: GoalType.milestone,
      milestones: [
        'Obtain full criminal record',
        'Research state expungement laws',
        'Consult with legal aid attorney',
        'Determine eligible charges',
        'File expungement petition (if eligible)',
      ],
      suggestedDurationDays: 90,
      whyThis:
          'Expungement can remove barriers to employment, housing, and other opportunities.',
    ),
  ];

  static const List<GoalTemplate> employment = [
    GoalTemplate(
      id: 'employment_resume',
      title: 'Create Professional Resume',
      description: 'Build a resume highlighting skills and experience.',
      category: GoalCategory.employment,
      type: GoalType.milestone,
      milestones: [
        'List all work experience and skills',
        'Use free resume builder or template',
        'Get feedback from job counselor',
        'Finalize and save in multiple formats',
      ],
      suggestedDurationDays: 14,
      whyThis:
          'A strong resume is the first step to getting interviews and employment.',
    ),
    GoalTemplate(
      id: 'employment_job_search',
      title: 'Apply to 10 Jobs',
      description: 'Submit applications to at least 10 positions.',
      category: GoalCategory.employment,
      type: GoalType.milestone,
      milestones: [
        'Create list of target employers',
        'Apply to 3 jobs',
        'Apply to 6 jobs',
        'Apply to 10 jobs',
      ],
      suggestedDurationDays: 21,
      whyThis:
          'Consistent job searching increases chances of finding employment.',
    ),
    GoalTemplate(
      id: 'employment_interview_skills',
      title: 'Practice Interview Skills',
      description: 'Prepare for job interviews with practice and coaching.',
      category: GoalCategory.employment,
      type: GoalType.milestone,
      milestones: [
        'Research common interview questions',
        'Write answers to key questions',
        'Do mock interview with counselor',
        'Prepare questions to ask employer',
      ],
      suggestedDurationDays: 14,
      whyThis:
          'Interview preparation increases confidence and success in landing a job.',
    ),
    GoalTemplate(
      id: 'employment_first_30_days',
      title: 'Succeed in First 30 Days of Employment',
      description: 'Build strong foundation in new job.',
      category: GoalCategory.employment,
      type: GoalType.milestone,
      milestones: [
        'Complete first week',
        'Learn all job duties',
        'Build relationships with coworkers',
        'Complete first month successfully',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'The first 30 days set the tone for long-term employment success.',
    ),
  ];

  static const List<GoalTemplate> housing = [
    GoalTemplate(
      id: 'housing_stable_temporary',
      title: 'Secure Stable Temporary Housing',
      description: 'Find and move into transitional or sober living housing.',
      category: GoalCategory.housing,
      type: GoalType.milestone,
      milestones: [
        'Research available housing options',
        'Contact housing programs',
        'Complete applications',
        'Secure placement',
        'Move in',
      ],
      suggestedDurationDays: 30,
      whyThis: 'Stable housing is essential for recovery and reentry success.',
    ),
    GoalTemplate(
      id: 'housing_save_deposit',
      title: 'Save for Apartment Deposit',
      description: 'Save money for first month and security deposit.',
      category: GoalCategory.housing,
      type: GoalType.milestone,
      milestones: [
        'Determine target amount needed',
        'Save 25% of goal',
        'Save 50% of goal',
        'Save 75% of goal',
        'Reach full deposit amount',
      ],
      suggestedDurationDays: 120,
      whyThis:
          'Financial preparation makes moving into permanent housing possible.',
    ),
    GoalTemplate(
      id: 'housing_rental_application',
      title: 'Prepare Strong Rental Application',
      description: 'Gather documents and references for apartment hunting.',
      category: GoalCategory.housing,
      type: GoalType.milestone,
      milestones: [
        'Get employment verification letter',
        'Gather pay stubs',
        'Get personal references',
        'Write explanation letter for background',
        'Organize all documents in folder',
      ],
      suggestedDurationDays: 21,
      whyThis:
          'Being prepared helps overcome barriers and secure housing faster.',
    ),
  ];

  static const List<GoalTemplate> health = [
    GoalTemplate(
      id: 'health_insurance',
      title: 'Get Health Insurance',
      description: 'Enroll in health coverage through Medicaid or marketplace.',
      category: GoalCategory.health,
      type: GoalType.milestone,
      milestones: [
        'Determine eligibility for Medicaid',
        'Gather required documents',
        'Complete application',
        'Receive insurance card',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Health insurance enables access to medical and mental health care.',
    ),
    GoalTemplate(
      id: 'health_primary_care',
      title: 'Establish Primary Care Doctor',
      description: 'Find and schedule first appointment with primary care physician.',
      category: GoalCategory.health,
      type: GoalType.milestone,
      milestones: [
        'Get referrals for doctors accepting my insurance',
        'Call to schedule appointment',
        'Attend first appointment',
        'Schedule follow-up if needed',
      ],
      suggestedDurationDays: 45,
      whyThis:
          'Regular medical care supports overall health and recovery.',
    ),
    GoalTemplate(
      id: 'health_mental_health',
      title: 'Start Mental Health Treatment',
      description: 'Connect with therapist or counselor for ongoing support.',
      category: GoalCategory.health,
      type: GoalType.milestone,
      milestones: [
        'Get mental health provider referrals',
        'Schedule intake appointment',
        'Attend first session',
        'Commit to regular sessions',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Mental health support is crucial for addressing trauma and building resilience.',
    ),
    GoalTemplate(
      id: 'health_exercise_routine',
      title: 'Build Exercise Routine',
      description: 'Establish regular physical activity habit.',
      category: GoalCategory.health,
      type: GoalType.continuous,
      milestones: [
        'Exercise 3 times in one week',
        'Exercise 7 consecutive days',
        'Exercise 14 consecutive days',
        'Exercise 30 consecutive days',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Physical activity improves mental health, reduces stress, and supports recovery.',
    ),
  ];

  static const List<GoalTemplate> community = [
    GoalTemplate(
      id: 'community_recovery_circle',
      title: 'Build Recovery Support Circle',
      description: 'Connect with at least 5 people in recovery.',
      category: GoalCategory.community,
      type: GoalType.milestone,
      milestones: [
        'Exchange numbers with 1 person at meeting',
        'Exchange numbers with 3 people',
        'Exchange numbers with 5 people',
        'Check in with support circle weekly',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Connection with others in recovery provides accountability and support.',
    ),
    GoalTemplate(
      id: 'community_service',
      title: 'Complete 20 Hours of Community Service',
      description: 'Give back through volunteer work.',
      category: GoalCategory.community,
      type: GoalType.milestone,
      milestones: [
        'Find volunteer opportunity',
        'Complete 5 hours',
        'Complete 10 hours',
        'Complete 15 hours',
        'Complete 20 hours',
      ],
      suggestedDurationDays: 60,
      whyThis:
          'Service builds purpose, connection, and demonstrates commitment to positive change.',
    ),
    GoalTemplate(
      id: 'community_reconnect_family',
      title: 'Rebuild Family Relationship',
      description: 'Take steps to reconnect with family member.',
      category: GoalCategory.community,
      type: GoalType.milestone,
      milestones: [
        'Write amends/reconnection letter',
        'Make initial contact',
        'Have first phone call or meeting',
        'Establish regular communication',
      ],
      suggestedDurationDays: 90,
      whyThis:
          'Healing family relationships supports long-term recovery and community connection.',
    ),
  ];

  static const List<GoalTemplate> personalGrowth = [
    GoalTemplate(
      id: 'growth_read_recovery_book',
      title: 'Read Recovery Literature',
      description: 'Complete a recovery-focused book.',
      category: GoalCategory.personalGrowth,
      type: GoalType.milestone,
      milestones: [
        'Choose a book',
        'Read 25% of book',
        'Read 50% of book',
        'Read 75% of book',
        'Complete book',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Recovery literature provides wisdom, perspective, and tools for growth.',
    ),
    GoalTemplate(
      id: 'growth_daily_journaling',
      title: 'Establish Daily Journaling Practice',
      description: 'Write in journal every day for 30 days.',
      category: GoalCategory.personalGrowth,
      type: GoalType.continuous,
      milestones: [
        '7 consecutive days',
        '14 consecutive days',
        '21 consecutive days',
        '30 consecutive days',
      ],
      suggestedDurationDays: 30,
      whyThis:
          'Journaling builds self-awareness and provides outlet for processing emotions.',
    ),
    GoalTemplate(
      id: 'growth_financial_literacy',
      title: 'Learn Basic Financial Management',
      description: 'Complete financial literacy course or workshop.',
      category: GoalCategory.personalGrowth,
      type: GoalType.milestone,
      milestones: [
        'Find free financial literacy course',
        'Complete budgeting module',
        'Complete saving module',
        'Complete credit module',
        'Create personal budget',
      ],
      suggestedDurationDays: 45,
      whyThis:
          'Financial skills are essential for independence and long-term stability.',
    ),
    GoalTemplate(
      id: 'growth_skill_development',
      title: 'Learn a New Skill',
      description: 'Take course or training to develop employable skill.',
      category: GoalCategory.personalGrowth,
      type: GoalType.milestone,
      milestones: [
        'Identify skill to learn',
        'Find free or affordable training',
        'Complete 25% of training',
        'Complete 75% of training',
        'Receive certificate or complete training',
      ],
      suggestedDurationDays: 90,
      whyThis:
          'New skills increase employment options and build confidence.',
    ),
  ];

  static List<GoalTemplate> getAllTemplates() {
    return [
      ...recovery,
      ...identityLegal,
      ...employment,
      ...housing,
      ...health,
      ...community,
      ...personalGrowth,
    ];
  }

  static List<GoalTemplate> getTemplatesByCategory(GoalCategory category) {
    switch (category) {
      case GoalCategory.recovery:
        return recovery;
      case GoalCategory.identityLegal:
        return identityLegal;
      case GoalCategory.employment:
        return employment;
      case GoalCategory.housing:
        return housing;
      case GoalCategory.health:
        return health;
      case GoalCategory.community:
        return community;
      case GoalCategory.personalGrowth:
        return personalGrowth;
    }
  }
}
