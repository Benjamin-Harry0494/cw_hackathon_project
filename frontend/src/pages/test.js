import {useEffect, useState} from 'react';
import {createWorker} from 'tesseract.js';

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
            <form onClick={parsePrescription}>
                {/*<form action="/read-prescription">*/}
                <input type="file" id="myFile" name="filename"/>
                <input type="submit"/>
            </form>

            <h2>Prescription Input</h2>
            <form action="/generate-prescription" method="post">

                <p>
                    <label htmlFor="name">Name:</label>
                    <input type="text" id="name" name="user_name"/>
                </p>
                <p>
                    <label htmlFor="mail">Email:</label>
                    <input type="email" id="mail" name="user_email"/>
                </p>
                <p>
                    <label htmlFor="msg">Message:</label>
                    <textarea id="msg" name="user_message"></textarea>
                </p>
            </form>


            <img src={"http://tesseract.projectnaptha.com/img/eng_bw.png"} alt={"poem"}/>

        </div>
    );
};

export default TestPage;
