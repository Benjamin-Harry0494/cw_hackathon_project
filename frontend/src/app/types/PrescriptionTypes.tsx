export type Prescription = {
    resourceType: string;
    dateWritten: Date;
    extension: Extension[];
    lensSpecification: LensSpecification[];
}

export type LensSpecification = {
    eye: String;
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
    url: String;
    valueDecimal: number;
}