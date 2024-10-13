import google.generativeai as genai
import json
import os
from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import HTMLResponse, RedirectResponse
import base64

genai.configure(api_key=os.environ["API_KEY"])
model = genai.GenerativeModel("gemini-1.5-flash")


app = FastAPI()

@app.post("/upload/")
async def upload_file(file: UploadFile = File(...), email: str = Form(...)):
    contents = await file.read()  # Read the file contents
    # Save the file
    with open(f"uploaded_{file.filename}", "wb") as f:
        f.write(contents)

    uploaded_file = genai.upload_file(f"uploaded_{file.filename}")
    # print(uploaded_file)
    query = """
    Return the data from this image using this schema. Make sure it is valid json
    
    {
        "resourceType": "VisionPrescription",
        "dateWritten": "<dateTime>", // When prescription was authorized
        "extension": [
            {
                "url": "BVD",
                "valueDecimal": <decimal> // Added inter-ADD power for multifocal levels
            }
        ],
        "lensSpecification": [
            {
                "eye": "<code>", // right | left
                "sphere": <decimal>, // Power of the lens
                "cylinder": <decimal>, // Lens power for astigmatism
                "axis": <integer>, // Lens meridian which contain no power for astigmatism
                "prism": [
                    {
                        "amount": <decimal>, // Amount of adjustment
                        "base": "<code>" // up | down | in | out
                    }
                ],
                "add": <decimal>, // Added near-ADD power for multifocal levels,
                "extension": [
                    {
                        "url": "inter-ADD",
                        "valueDecimal": <decimal> // Added inter-ADD power for multifocal levels
                    }
                ]
            }
        ]
    }"""
    response = model.generate_content(
        [uploaded_file, query]
    )
    clean_response = response.text.strip()
    clean_response = clean_response[7:-3]
    # clean_response = clean_response.replace('None', 'null').replace('\n', '')

    response_encoded = base64.b64encode(clean_response.encode('utf-8')).decode('utf-8')

    return RedirectResponse(f"http://localhost:3000/test?email={email}&prescription={response_encoded}")


    # return {"email": email, "prescription": json.loads(clean_response[7:-3])}

@app.get("/")
async def main():
    html_content = """
    <html>
        <head>
            <title>Camera Upload</title>
        </head>
        <body>
            <h3>Upload a photo and provide your email</h3>
            <form action="/upload/" enctype="multipart/form-data" method="post">
                <label for="email">Email:</label>
                <input type="email" name="email" required><br><br>
                <label for="file">Photo:</label>
                <input type="file" accept="image/*" capture="camera" name="file" required><br><br>
                <input type="submit">
            </form>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)