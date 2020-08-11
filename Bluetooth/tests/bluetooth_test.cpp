#include <gtest/gtest.h>

bool bluetooth_connection(){
    return true;
}

struct BluetoothTest : public ::testing::Test {

    virtual void SetUp() override {}

    virtual void TearDown() override {}
};

TEST_F(BluetoothTest, CheckConnection) {

    EXPECT_EQ(bluetooth_connection(), true);
    EXPECT_EQ(bluetooth_connection(), true);
}
