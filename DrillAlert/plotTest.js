var testConfig = {yMax : 40, xMax : 10, data : [1, 2, 3, 4, 5, 6, 7, 6, 5], 
	idata: [0, 1, 2, 3, 4, 5, 6, 7, 8], width : 500, height : 300, id : 0};
master.init(testConfig);

QUnit.test('init test', function (assert) {
    assert.equal(master.id, testConfig[id]);
    assert.equal(master.xMax, testConfig[xMax]);
    assert.equal(master.yMax, testConfig[yMax]);
});

QUnit.test('tick test', function (assert) {
    var testConfig = {yMax : 40, xMax : 10, data : [1, 2, 3, 4, 5, 6, 7, 6, 5], 
	idata: [0, 1, 2, 3, 4, 5, 6, 7, 8], width : 500, height : 300, id : 1};
master.init(testConfig);
    master.tick(4, 8.5, 1);
    
    assert.equal(master[1].data[master[1].data.length - 1], 4);
    assert.equal(master[1].idata[master[1].idata.length - 1], 8.5);
});

QUnit.test('tick test2', function (assert) {
    var testConfig = {yMax : 10, xMax : 10, data : [1, 2, 3, 4, 5, 6, 7, 6, 5], 
	idata: [0, 1, 2, 3, 4, 5, 6, 7, 8], width : 500, height : 300, id : 2};
    master.init(testConfig);
    master.tick(2, 9, 2);
    
    assert.equal(master[2].data[master[2].data.length - 1], 2);
    assert.equal(master[2].idata[master[2].idata.length - 1], 9);
    
    master.tick(5, 10, 2);
    
    assert.equal(master[2].data[master[2].data.length - 1], 5);
    assert.equal(master[2].idata[master[2].idata.length - 1], 10);
});
