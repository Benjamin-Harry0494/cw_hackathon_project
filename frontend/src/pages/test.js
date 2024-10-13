import {useEffect, useState} from 'react';
import {createWorker} from 'tesseract.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import PrescriptionInfoForm from "../app/components/PrescriptionInfoForm";
import '../app/styles/FormStyle.css'
import { useRouter } from 'next/router';
import QRCode from "react-qr-code";

const TestPage = () => {
    const [message, setMessage] = useState('');
    const router = useRouter();

    const {email, prescription} = router.query;

    //base64decode the prescription
    const decodedPrescription = prescription ? atob(prescription) : null;

    //convert string to json
    const jsonPrescription = JSON.parse(decodedPrescription);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('http://localhost:3001/api/v1/test');
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                const data = await response.json();
                setMessage(data.message);
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        };
        fetchData();
    }, []);

    return (
        <div>
            <h1>Find My Eye Test</h1>

            <h3> Upload Prescription</h3>
            <div>
                <PrescriptionInfoForm prescription={jsonPrescription} />
            </div>
            <p>
                {decodedPrescription}
            </p>
            {/*<QRCode value={}></QRCode>*/}
        </div>
    );
};

export default TestPage;
