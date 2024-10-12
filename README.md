Navigate to http://localhost:3000/test

-- Calls into rails that is expected to be running on http://localhost:3001/

-- Exact call goes to http://localhost:3001/api/v1/test detailed in config/routes.rb

-- Renders below page : 

<img width="239" alt="Screenshot 2024-10-11 at 10 10 41" src="https://github.com/user-attachments/assets/912e91d3-f047-4dca-9547-5af10aecc911">

## JSON Schema

Adapted from FHIR: https://www.hl7.org/fhir/visionprescription.html

```yaml
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
}
```

## Before running
Use ruby 2.7.8
Run bundle exec
Run npm install

## How to Run
In root of directory, open a terminal and execute
`rails server -p 3001`

Then in separate terminal change to the frontend directory
`cd frontend`

then run
`pnpm dev`
or
`npm run`