import {useEffect, useState} from 'react';
import {createWorker} from 'tesseract.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import PrescriptionInfoForm from "../app/components/PrescriptionInfoForm";

const TestPage = () => {
    const [message, setMessage] = useState('');

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


    (async () => {
        // const worker = await createWorker('eng');
        const worker = await createWorker('eng', 1, {
            logger: m => console.log(m),
        });

        // const ret = await worker.recognize('http://localhost:3001/images/eng_bw.png');
        // const ret = await worker.recognize('frontend/src/app/images/eng_bw.png');
        // const ret = await worker.recognize('https://tesseract.projectnaptha.com/img/eng_bw.png');
        // console.log(ret);
        await worker.terminate();
    })();

    const parsePrescription = () => {
        console.log("Parsing prescription");
    }

    return (
        <div>
            <h1>Test API Response</h1>
            <p>{message}</p>

            <h2> Upload Prescription</h2>
            <PrescriptionInfoForm/>

            <img src={"http://tesseract.projectnaptha.com/img/eng_bw.png"} alt={"poem"}/>

        </div>
    );
};

export default TestPage;
