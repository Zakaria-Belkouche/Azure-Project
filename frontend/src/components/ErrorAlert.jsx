function ErrorAlert({ message }) {
    // Do not render anything if there is no error message
    if (!message) return null;

    return (
        <div className="text-sm text-red-600 bg-red-50 border border-red-200 px-3 py-2 rounded-lg">
            {message}
        </div>
    );
}

export default ErrorAlert;
