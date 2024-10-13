import Button from 'react-bootstrap/Button';
import {Prescription} from "@/app/types/PrescriptionTypes";
import {useForm} from "@tanstack/react-form";
import {Label, Input, NumberField, DateField, DateInput, DateSegment, TextField} from 'react-aria-components';

export const PrescriptionInfoForm = (prescription: Prescription) => {
    const emptyPrescription: Prescription = {
        resourceType: "VisionPrescription",
        patientName: "",
        dateWritten: new Date(),
        extension: [],
        lensSpecification: [{
            eye: "left",
            sphere: 0,
            cylinder: 0,
            axis: 0,
            prism: [],
            add: 0,
            extension: []
        }, {
            eye: "right",
            sphere: 0,
            cylinder: 0,
            axis: 0,
            prism: [],
            add: 0,
            extension: []
        }],
    }

    const form = useForm({
        defaultValues: prescription.prescription || emptyPrescription,
        onSubmit: async ({value}) => {
            const response = await fetch('http://localhost:3000/api/v1/ocr_record/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({prescription: value}),
            });
            console.log("Calling for value: ");
            console.log(value)
            console.log("Got response: ")
            console.log(response)
        }
    })

    // TODO: BVD data format isn't great
    // TODO: Formatting and styling in general not great
    return (
        <div style={{padding: 15, width: "75%"}}>
            <form onSubmit={(e) => {
                e.preventDefault();
                e.stopPropagation();
                form.handleSubmit();
            }}>
                <fieldset>
                    <form.Field
                        name={`patientName`}
                        children={(field) => (
                            <TextField>
                                <Label htmlFor={field.name}>Patient Name: </Label>
                                <Input
                                    name={field.name}
                                    type="text"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </TextField>
                        )}
                    />
                </fieldset>
                <fieldset>
                    <form.Field
                        name={`patientEmail`}
                        children={(field) => (
                            <TextField>
                                <Label htmlFor={field.name}>Patient Email: </Label>
                                <Input
                                    name={field.name}
                                    type="text"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </TextField>
                        )}
                    />
                </fieldset>
                {/*<fieldset>*/}
                {/*    <form.Field*/}
                {/*        name="dateWritten"*/}
                {/*        children={() => (*/}
                {/*            <DateField>*/}
                {/*                <Label>Date of prescription: </Label>*/}
                {/*                <DateInput>*/}
                {/*                    {segment => <DateSegment segment={segment}/>}*/}
                {/*                </DateInput>*/}
                {/*            </DateField>*/}
                {/*        )}*/}
                {/*    />*/}
                {/*</fieldset>*/}
                <fieldset>
                    <legend>Left Eye</legend>
                    <form.Field
                        name={`lensSpecification[${0}].sphere`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Sphere (SPH): </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].cylinder`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Cylinder (CYL): </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].axis`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Axis: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].prism[${0}].amount`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Prism Amount: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].prism[${0}].base`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Prism Base: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].add`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Add: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${0}].extension[${0}].valueDecimal`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}> Back Vertex Distance (BVD): </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                </fieldset>
                <fieldset>
                    <legend>Right Eye</legend>
                    <form.Field
                        name={`lensSpecification[${1}].sphere`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Sphere: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].cylinder`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Cylinder: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].axis`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Axis: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].prism[${0}].amount`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Prism Amount: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].prism[${0}].base`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Prism Base: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].add`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}>Add: </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                    <form.Field
                        name={`lensSpecification[${1}].extension[${0}].valueDecimal`}
                        children={(field) => (
                            <NumberField>
                                <Label htmlFor={field.name}> Back Vertex Distance (BVD): </Label>
                                <Input
                                    name={field.name}
                                    type="number"
                                    value={field.state.value}
                                    onBlur={field.handleBlur}
                                    onChange={(e) => field.handleChange(e.target.value)}
                                />
                            </NumberField>
                        )}
                    />
                </fieldset>
                <div></div>
                <Button type="submit" style={{width: "50%"}}>Submit</Button>
            </form>
        </div>
    );
}

export default PrescriptionInfoForm;