function CheckButton({ loading, onClick }) {
    return (
        // function to call when button is clicked, disable button while checking
        <button
            onClick={onClick}
            disabled={loading}
            className="uppercase w-full py-2 rounded-lg bg-green-600 text-white font-semibold hover:bg-green-700 disabled:opacity-70"
        >
            {/* Switch text depending on loading state */}
            {loading ? 'Checking...' : 'Check spelling'}
        </button>
    );
}

export default CheckButton;
