import { useState } from 'react';

export default function QrCodePage() {
    const [qrCodeUrl, setQrCodeUrl] = useState(null); // Store QR code URL
    const [error, setError] = useState(null); // Store any potential error
    const [loading, setLoading] = useState(false); // Track the loading state

    // Function to fetch the QR code from your API route
    const fetchQrCode = async () => {
        setLoading(true); // Start loading when fetching begins
        setError(null);

        try {
            const response = await fetch('http://localhost:3001/api/v1/ocr_record/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    user_id: '123',
                    document_data: 'example_document_data',
                }),
            });

            if (!response.ok) {
                throw new Error('Failed to fetch the QR code');
            }

            const data = await response.json(); // Get the JSON response

            setQrCodeUrl(data.qr_code_url); // Set the QR code URL in state
        } catch (err) {
            setError(err.message); // Handle any error
        } finally {
            setLoading(false); // Stop loading after fetch completes
        }
    };

    return (
        <div style={{ textAlign: 'center', marginTop: '50px' }}>
            <h1>QR Code</h1>
            <button onClick={fetchQrCode} style={{ padding: '10px', fontSize: '16px', cursor: 'pointer' }}>
                Fetch QR Code
            </button>

            {loading && <p>Loading...</p>} {/* Show loading state */}

            {error && <p style={{ color: 'red' }}>{error}</p>} {/* Show error message */}

            {qrCodeUrl && (
                <div>
                    <p>QR Code URL:</p>
                    <img src={qrCodeUrl} alt="QR Code" style={{ marginTop: '20px', width: '300px', height: '300px' }} />
                </div>
            )}
        </div>
    );
}