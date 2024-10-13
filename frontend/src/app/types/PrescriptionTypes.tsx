export type Prescription = {
    resourceType: string;
    patientName: string;
    patientEmail: string;
    dateWritten: Date;
    extension: Extension[];
    lensSpecification: LensSpecification[];
}

export type LensSpecification = {
    eye: string;
    sphere: number;
    cylinder: number;
    axis: number;
    prism: Prism[]
    add: number;
    extension: Extension[]
};

export type Prism = {
    amount: number;
    base: string;
}

export type Extension = {
    url: string;
    valueDecimal: number;
}