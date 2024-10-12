import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';

function PrescriptionInfoForm() {
    return (
        <Form action="/api/v1/submit_prescription" method="POST">
            <fieldset>
                <Form.Group className="">
                    <Form.Label>Date of prescription (YYYY-MM-DD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter date here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye sphere (SPH)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye cylinder (CYL)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye prism</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye add (ADD or near-ADD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye inter-add (inter-ADD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Right eye Back Vertex Distance (BVD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye sphere (SPH)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye cylinder (CYL)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye prism</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye add (ADD or near-ADD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye inter-add (inter-ADD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Form.Group className="">
                    <Form.Label>Left eye Back Vertex Distance (BVD)</Form.Label>
                    <Form.Control type="text" placeholder="Enter number here" />
                </Form.Group>
                <Button type="submit">Submit</Button>
            </fieldset>
        </Form>
    );
}

export default PrescriptionInfoForm;