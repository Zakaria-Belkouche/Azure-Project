function TextInput({ label, value, onChange, placeholder }) {
    return (
        <div className="space-y-2">
            <label className="block text-lg font-medium text-slate-700">{label}</label>
            <textarea
                className="w-full h-32 border rounded-lg p-3 text-lg focus:outline-none focus:ring-2 focus:ring-indigo-500"
                value={value}
                onChange={onChange}
                placeholder={placeholder}
            />
        </div>
    );
}

export default TextInput;
