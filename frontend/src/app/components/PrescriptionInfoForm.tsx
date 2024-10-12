import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';

function PrescriptionInfoForm() {
    return (
        <Form>
            <fieldset disabled>
                <Form.Group className="">
                    <Form.Label>Label 1</Form.Label>
                    <Form.Control placeholder="Placeholder text" />
                </Form.Group>
                <Form.Group className="mb-3">
                    <Form.Label htmlFor="disabledSelect">Disabled select menu</Form.Label>
                    <Form.Select id="disabledSelect">
                        <option>Disabled select</option>
                    </Form.Select>
                </Form.Group>
                <Form.Group className="mb-3">
                    <Form.Check
                        type="checkbox"
                        id="disabledFieldsetCheck"
                        label="Can't check this"
                    />
                </Form.Group>
                <Button type="submit">Submit</Button>
            </fieldset>
        </Form>
    );
}

export default PrescriptionInfoForm;