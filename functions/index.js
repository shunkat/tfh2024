const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { OpenAI } = require('openai');

admin.initializeApp();

// OpenAIの設定
const openai = new OpenAI({
    apiKey: functions.config().openai.key,
});

// Firestoreトリガー関数
exports.checkComment = functions.firestore
  .document('pdfs/{pdfId}/comments/{commentId}')
  .onCreate(async (snap, context) => {
    const commentData = snap.data();
    const text = commentData.content; // 'text'を'content'に変更

    try {
      // コメントが盛り上がるかどうかをチェック
      const isExciting = await checkIfExciting(text);

      let finalText = text;

      if (!isExciting) {
        // コメントを盛り上がるように修正
        finalText = await makeCommentExciting(text);
      }

      // goodCommentsコレクションに追加
      await admin.firestore()
        .collection('goodComments')
        .add({
          ...commentData,
          content: finalText, // 'text'を'content'に変更
        });

      console.log('Comment processed and added to goodComments.');
    } catch (error) {
      console.error('Error processing comment:', error);
    }
  });

// コメントが盛り上がるかどうかをチェックする関数
async function checkIfExciting(text) {
  const messages = [
    {
      role: 'user',
      content: `以下のコメントが盛り上がるかどうかを「はい」か「いいえ」で答えてください。\nコメント: "${text}"`,
    },
  ];

  try {
    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: messages,
      max_tokens: 10,
    });

    const answer = response.data.choices[0].message.content.trim();
    return answer.includes('はい');
  } catch (error) {
    console.error('Error in checkIfExciting:', error);
    throw error;
  }
}

// コメントを盛り上がるように修正する関数
async function makeCommentExciting(text) {
  const messages = [
    {
      role: 'user',
      content: `以下のコメントを、もっと盛り上がる感じに修正してください。\n元のコメント: "${text}"\n修正後のコメント:`,
    },
  ];

  try {
    const response = await openai.createChatCompletion({
      model: 'gpt-4',
      messages: messages,
      max_tokens: 60,
    });

    return response.data.choices[0].message.content.trim();
  } catch (error) {
    console.error('Error in makeCommentExciting:', error);
    throw error;
  }
}