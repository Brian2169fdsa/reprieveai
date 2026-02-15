import { NextRequest, NextResponse } from 'next/server';

export const runtime = 'nodejs';

type CheckinRequest = {
  systemPrompt: string;
  userPrompt: string;
};

export async function POST(request: NextRequest) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: 'Missing OPENAI_API_KEY.' }, { status: 500 });
  }

  let payload: CheckinRequest;
  try {
    payload = (await request.json()) as CheckinRequest;
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body.' }, { status: 400 });
  }

  if (!payload.systemPrompt || !payload.userPrompt) {
    return NextResponse.json(
      { error: 'Both systemPrompt and userPrompt are required.' },
      { status: 400 },
    );
  }

  const openAIResponse = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4.1-mini',
      temperature: 0.5,
      messages: [
        {
          role: 'system',
          content: payload.systemPrompt,
        },
        {
          role: 'user',
          content: payload.userPrompt,
        },
      ],
    }),
  });

  if (!openAIResponse.ok) {
    const errorBody = await openAIResponse.text();
    return NextResponse.json(
      { error: `OpenAI request failed: ${errorBody}` },
      { status: openAIResponse.status },
    );
  }

  const data = (await openAIResponse.json()) as {
    choices?: Array<{ message?: { content?: string } }>;
  };

  const content = data.choices?.[0]?.message?.content?.trim();
  if (!content) {
    return NextResponse.json({ error: 'No response content from OpenAI.' }, { status: 502 });
  }

  try {
    return NextResponse.json({ result: JSON.parse(content) });
  } catch {
    return NextResponse.json({ result: { raw: content } });
  }
}
