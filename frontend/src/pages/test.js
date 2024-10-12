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
        console.log("STUFF IS HAPPENING!")
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

            <div className="container">
                <p>
                    Here's a paragraph. It's a very interesting paragraph. You are captivated by
                    this paragraph. Keep reading this paragraph. Okay, now you can stop reading
                    this paragraph. Thanks for reading me.
                </p>
            </div>

            <h2> Upload Prescription</h2>
            <PrescriptionInfoForm/>

            {/*<img src={"http://tesseract.projectnaptha.com/img/eng_bw.png"} alt={"poem"}/>*/}

        </div>
    );
};

export default TestPage;
