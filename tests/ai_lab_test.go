package test

import (
	"encoding/json"
	"os"
	"os/exec"
	"testing"
)

type resourceGroup struct {
	Name string            `json:"name"`
	Tags map[string]string `json:"tags"`
}

func TestLiveResourceGroupTags(t *testing.T) {
	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if subscriptionID == "" {
		t.Skip("ARM_SUBSCRIPTION_ID not set, skipping live Azure checks")
	}

	resourceGroupName := os.Getenv("AI_LAB_RESOURCE_GROUP")
	if resourceGroupName == "" {
		t.Skip("AI_LAB_RESOURCE_GROUP not set, skipping random-suffix resource group check")
	}

	cmd := exec.Command("az", "group", "show", "--subscription", subscriptionID, "--name", resourceGroupName, "-o", "json")

	output, err := cmd.Output()
	if err != nil {
		t.Fatalf("failed to read resource group %s: %v", resourceGroupName, err)
	}

	var group resourceGroup
	if err := json.Unmarshal(output, &group); err != nil {
		t.Fatalf("failed to parse az group output: %v", err)
	}

	if group.Tags["Environment"] == "" {
		t.Fatalf("expected Environment tag on %s", group.Name)
	}

	if group.Tags["Project"] != "AI Lab" {
		t.Fatalf("expected Project tag to be AI Lab, got %q", group.Tags["Project"])
	}
}
