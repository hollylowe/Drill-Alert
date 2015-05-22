 QUnit.test(
"test basic value update to 3.0"
,
function
( assert ) {
var
config = {
size: 300,
clipWidth: 300,
clipHeight: 300,
ringWidth: 60,
maxValue: 10,
transitionMs: 4000,
id: 0
};
assert.equal( config.size, 300,
"Size should be 300"
);
masterGauge.init(config);
masterGauge.update(3, 0);
});

 QUnit.test(
"test too large update"
,
function
( assert ) {
var
config = {
size: 300,
clipWidth: 300,
clipHeight: 300,
ringWidth: 60,
maxValue: 10,
transitionMs: 4000,
id: 0
};
masterGauge.init(config);
masterGauge.update(11, 0);
assert.ok(
"test update to 11"
);
}); 

QUnit.test(
"test change in size"
,
function
( assert ) {
var
config = {
size: 500,
clipWidth: 500,
clipHeight: 300,
ringWidth: 60,
maxValue: 10,
transitionMs: 4000,
id: 0
};
masterGauge.init(config);
assert.ok(
"change in size"
);
}); 

 QUnit.test(
"test change in radius"
,
function
( assert ) {
var
config = {
size: 500,
clipWidth: 500,
clipHeight: 300,
ringWidth: 200,
maxValue: 10,
transitionMs: 4000,
id: 0
};
masterGauge.init(config);
assert.ok(
"change in radius"
);
}); 

QUnit.test(
"test change in maxvalue"
,
function
( assert ) {
var
config = {
size: 500,
clipWidth: 500,
clipHeight: 300,
ringWidth: 60,
maxValue: 100,
transitionMs: 4000,
id: 0
};
masterGauge.init(config);
assert.ok(
"change in max value"
);
}); 
