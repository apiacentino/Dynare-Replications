

var
k // per capita capital stock
c // per capita consumption
y // per capita income
;

varexo
s //saving rate
;

parameters
ALPHA // capital share
DELTA // depreciation rate of capital stock
n // population growth
MU //technological progress
;

ALPHA = 0.33;
DELTA = 0.02;
n = 0; //no population growth
MU = 0; //no technological progress


%------------------------| MODEL |------------------------%
model;

//law of motion of capital
k = (1/(1 + n + MU))*(s*k(-1)^ALPHA + (1 - DELTA)*k(-1));

//per capita production function
y = k^ALPHA;

//per capita consumption
c = (1 - s)*y;

end;


%---------------------| INITIAL VALUES |------------------%
initval;
s = 0.3;
k = (s/(DELTA + MU + n))^(1/(1 - ALPHA));
y = k^ALPHA;
c = (1 - s)*y;
end;

%----------------------| SHOCKS |--------------------------%
shocks;
var s;
periods 10:50;
values 0.5;
end;

%--------------| NON STOCHASTIC SIMULATION |----------------%
perfect_foresight_setup(periods=50); //number of periods is set to 50
perfect_foresight_solver;


%--------------------| PLOT SIMULATION |--------------------%
%rplot k;
%rplot c;
%rplot y;
%rplot s;



%---------------| STEADY STATE COMPUTATIONS| ---------------%
k_ss = ((M_.det_shocks.value)/(DELTA + MU + n))^(1/(1 - ALPHA));
y_ss = k_ss^ALPHA;
c_ss = (1 - M_.det_shocks.value)*y_ss;

%--------------------| PLOT SIMULATION |--------------------%
figure('Name','Dynamics');

%CAPITAL
subplot(2,2,1);
plot(k,"LineWidth", 1.5);
title("Capital Stock (k)");
xlabel("Time");
ylabel("k");
hold on;
plot([xlim], [k_ss,k_ss],"r--","LineWidth",1.2); //steady state line



%CONSUMPTION
subplot(2,2,2);
plot(c,"LineWidth", 1.5);
title("Consumption (c)");
xlabel("Time");
ylabel("c");
hold on;
plot([xlim], [c_ss,c_ss],"r--","LineWidth",1.2); //steady state line


%OUTPUT
subplot(2,2,3);
plot(y,"LineWidth", 1.5);
title("Output (y)");
xlabel("Time");
ylabel("y");
hold on;
plot([xlim], [y_ss,y_ss],"r--","LineWidth",1.2); //steady state line


%SAVING RATE
subplot(2,2,4);
plot(oo_.exo_simul,"LineWidth", 1.5);
title("Saving Rate (s)");
xlabel("Time");
ylabel("s");


saveas(gcf,"Solow_Dynamics.pdf"); //save all dynamics












