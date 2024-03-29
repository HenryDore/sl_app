classdef gas_use
    %GAS_USE Summary of this class goes here
    % Setup electriticy use for each process as seperate, so can make them
    % asynchronous
    %   Detailed explanation goes here

%% UPDATE FOR THERMAL ENERGY BASE ON WIDER LHV OF RANGE OF MATERIALS 

    properties
        Composition     % Composition of the Gas
        Component_Ratios
        CExC
        CEnC
        CO2
        LHV
        Consumption     % Amount of Gas required (kg/hr)
        Requirement     % Total of gas required (kg/hr) amount required
    end

    methods
        function obj = gas_use(Composition,Ratio)
            %ELECTRICITY Construct an instance of this class
            %   Detailed explanation goes here

            % Contributions are from chemical database to ensure
            % varibility/updates

            obj.Composition = Composition;
            obj.Component_Ratios = Ratio;

        end

        function obj = process_gas_use(obj,ConsumptionRate,MassFlowRate)

            % Duration in hours (based on machine processing rate

            obj.Consumption = ConsumptionRate; %  MJ/hr of machine give kgs of mix required


            % Ignoring calorific value of gas mixture at this stage

            % Mass flow rate is kg of gas to make kg of yogurt (based on paper)
            % massflowRate input is TOTAL gas useage for process in kg

            % obj.Requirement = MassFlowRate; % Total kg of gas mixture required (here can change to total energy required and from that kg

            %Energy requirement of gas mixture based on kg of 'Natural gas'
            % therefore - calculate MJ required of TOTAL gas needed based
            % on paper
            Energy_Needed_MJ = MassFlowRate*50; % Here 50 is 50 MJ/kg of combusted natural Gas.

            % Need to determine a combined LHV of the mixture and back out
            % components
            for i = 1:length(obj.Composition)
                LHV_i(i) = obj.Component_Ratios(i)*obj.Composition(i).LHV;
            end


            obj.LHV = sum(LHV_i);

            % Determine amount of gas MIXTURE needed based on TOTAL Energy
            % needed to give mass flow rate (kg) of each part of mixture
            % base this on component ratios and LHV - not t hermodynamically
            % sound but a start point

            obj.Requirement = Energy_Needed_MJ/obj.LHV;

            for i = 1:length(obj.Composition)
                CExCi(i) = (obj.Requirement*obj.Component_Ratios(i))*obj.Composition(i).CExC; % Give indiviudal mass contribution
                CEnCi(i) = (obj.Requirement*obj.Component_Ratios(i))*obj.Composition(i).CEnC; % Give indiviudal mass contribution
                CO2i(i) = (obj.Requirement*obj.Component_Ratios(i))*obj.Composition(i).CO2*obj.Composition(i).CEnC; % Give indiviudal mass contribution

            end

            obj.CEnC = sum(CEnCi);
            obj.CExC = sum(CExCi);
            obj.CO2 = sum(CO2i);

        end

    end
end

