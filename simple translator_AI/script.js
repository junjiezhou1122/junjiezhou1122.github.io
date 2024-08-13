let apiKey = '';

function saveApiKey() {
    apiKey = document.getElementById('apiKey').value.trim();
    if (apiKey) {
        localStorage.setItem('openaiApiKey', apiKey);
        alert('API key saved!');
    } else {
        alert('Please enter a valid API key.');
    }
}

function loadApiKey() {
    const savedApiKey = localStorage.getItem('openaiApiKey');
    if (savedApiKey) {
        apiKey = savedApiKey;
        document.getElementById('apiKey').value = apiKey;
    }
}

async function translate() {
    if (!apiKey) {
        alert('Please enter your OpenAI API key first!');
        return;
    }

    const inputText = document.getElementById('inputText').value.trim();
    const targetLang = document.getElementById('targetLang').value;
    const outputText = document.getElementById('outputText');

    if (!inputText) {
        alert('Please enter some text to translate!');
        return;
    }

    outputText.innerText = 'Translating...';

    const languageNames = {
        'es': 'Spanish',
        'fr': 'French',
        'de': 'German',
        'ja': 'Japanese',
        'zh': 'Chinese (Simplified)'
    };

    try {
        const response = await fetch('https://api.openai.com/v1/chat/completions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${apiKey}`
            },
            body: JSON.stringify({
                model: "gpt-3.5-turbo",
                messages: [
                    {
                        role: "system",
                        content: `You are a helpful assistant that translates text to ${languageNames[targetLang]}.`
                    },
                    {
                        role: "user",
                        content: `Translate the following text to ${languageNames[targetLang]}: "${inputText}"`
                    }
                ]
            })
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        if (data.choices && data.choices[0] && data.choices[0].message) {
            outputText.innerText = data.choices[0].message.content;
        } else {
            throw new Error('Unexpected response from OpenAI API');
        }
    } catch (error) {
        console.error('Error:', error);
        outputText.innerText = `An error occurred during translation: ${error.message}. Please check your API key and try again.`;
    }
}

function initializeApp() {
    loadApiKey();
    document.getElementById('saveApiKeyBtn').addEventListener('click', saveApiKey);
    document.getElementById('translateBtn').addEventListener('click', translate);
}

// Initialize the app when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', initializeApp);