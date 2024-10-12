Navigate to http://localhost:3000/test

-- Calls into rails that is expected to be running on http://localhost:3001/

-- Exact call goes to http://localhost:3001/api/v1/test detailed in config/routes.rb

-- Renders below page : 

<img width="239" alt="Screenshot 2024-10-11 at 10 10 41" src="https://github.com/user-attachments/assets/912e91d3-f047-4dca-9547-5af10aecc911">

## JSON Schema

Adapted from FHIR: https://www.hl7.org/fhir/visionprescription.html

{
  "resourceType" : "VisionPrescription",
  // from Resource: id, meta, implicitRules, and language
  // from DomainResource: text, contained, extension, and modifierExtension
  "dateWritten" : "<dateTime>", // R!  When prescription was authorized
  "extension": [{
        "url": "BVD",
        "valueDecimal": <decimal> // Added inter-ADD power for multifocal levels
    }],
  "lensSpecification" : [{ // R!  Vision lens authorization
    "eye" : "<code>", // R!  right | left
    "sphere" : <decimal>, // Power of the lens
    "cylinder" : <decimal>, // Lens power for astigmatism
    "axis" : <integer>, // Lens meridian which contain no power for astigmatism
    "prism" : [{ // Eye alignment compensation
      "amount" : <decimal>, // R!  Amount of adjustment
      "base" : "<code>" // R!  up | down | in | out
    }],
    "add" : <decimal>, // Added near-ADD power for multifocal levels,
    "extension": [{
        "url": "inter-ADD",
        "valueDecimal": <decimal> // Added inter-ADD power for multifocal levels
    }]
  }]
}