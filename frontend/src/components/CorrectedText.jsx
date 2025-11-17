function CorrectedText({ text }) {
    // If there is no corrected text, do not render anything
    if (!text) return null;

    return (
        <div className="space-y-2">
            <h2 className="text-lg font-medium text-slate-700">Corrected text</h2>
            <p className="border rounded-lg p-3 text-sm bg-slate-50 whitespace-pre-wrap">{text}</p>
        </div>
    );
}

export default CorrectedText;
