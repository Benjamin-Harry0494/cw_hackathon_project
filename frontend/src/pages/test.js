import {useEffect, useState} from 'react';
import {createWorker} from 'tesseract.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import PrescriptionInfoForm from "../app/components/PrescriptionInfoForm";
import '../app/styles/FormStyle.css'
import { useRouter } from 'next/router';

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


    let ocr = (async () => {
        const worker = await createWorker('eng');
        // const worker = await createWorker('eng', 1, {
        //     logger: m => console.log(m),
        // });

        const url = 'https://tesseract.projectnaptha.com/img/eng_bw.png';
        // const url = 'frontend/src/app/images/eng_bw.png';
        // const url = 'http://localhost:3001/images/eng_bw.png';

        // let image = loadImage(url);
        // const ret = await worker.recognize(image);
        // console.log(ret);
        await worker.terminate();
    })();

    const parsePrescription = () => {
        console.log("Parsing prescription");
    }

    // const container = document.querySelector(".container");


    // function loadImage(url) {
    //     const image = new Image(200, 200);
    //     image.addEventListener("load", () => container.prepend(image));
    //
    //     image.addEventListener("error", () => {
    //         const errMsg = document.createElement("output");
    //         errMsg.value = `Error loading image at ${url}`;
    //         container.append(errMsg);
    //     });
    //
    //     image.crossOrigin = "anonymous";
    //     image.alt = "";
    //     image.src = url;
    //
    //     return image;
    // }

    return (
        <div>
            <h1>Test API Response</h1>
            <p>{message}</p>

            <h3> Upload Prescription</h3>
            <div>
                <PrescriptionInfoForm prescription={jsonPrescription} />
                {/* <p>Loading prescription data...</p> */}
            </div>            
            <p>
                {/* {jsonprescription} */}
                {decodedPrescription}
            </p>
        </div>
    );
};

export default TestPage;
