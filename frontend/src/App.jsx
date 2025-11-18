import { useState } from 'react';
import TextInput from './components/TextInput';
import CheckButton from './components/CheckButton';
import ErrorAlert from './components/ErrorAlert';
import CorrectedText from './components/CorrectedText';

// Base URL for Django API
const API_BASE = 'http://98.71.176.73:8000/api';

function App() {
    // Component state values

    // user input text
    const [text, setText] = useState('');
    // corrected text from API
    const [corrected, setCorrected] = useState('');
    // error message
    const [error, setError] = useState('');
    // loading state for button
    const [loading, setLoading] = useState(false);

    // Function to send text to Django API for correction
    const handleCheck = async () => {
        setError('');
        setCorrected('');

        // Validate input
        if (!text.trim()) {
            setError('Please enter some text.');
            return;
        }

        setLoading(true);

        try {
            // POST request to Django endpoint
            const resp = await fetch(`${API_BASE}/spellcheck/`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text }),
            });
            // If server responds with error status
            if (!resp.ok) {
                throw new Error('API error');
            }
            // Parse JSON response from backend
            const data = await resp.json();
            setCorrected(data.corrected_text);
        } catch (e) {
            console.error(e);
            setError('Failed to check text. Check if the Django API is running');
        } finally {
            // Remove loading spinner / disable state
            setLoading(false);
        }
    };

    return (
        <div className="bg-gray-700 min-h-screen flex items-center justify-center px-4">
            <div className="bg-green-50 max-w-2xl w-full rounded-2xl shadow-lg p-6 space-y-6">
                <h1 className="uppercase text-2xl font-bold text-slate-800 text-center">Spell Checker</h1>

                <TextInput
                    label="Enter text"
                    value={text}
                    onChange={(e) => setText(e.target.value)}
                    placeholder="Type English text here..."
                />

                <CheckButton loading={loading} onClick={handleCheck} />

                <ErrorAlert message={error} />

                <CorrectedText text={corrected} />
            </div>
        </div>
    );
}

export default App;
