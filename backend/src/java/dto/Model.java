package dto;

public class Model {
    private int modelId;
    private String modelName;
    private int brandId;

    public Model() {}

    public Model(int modelId, String modelName, int brandId) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.brandId = brandId;
    }

    public int getModelId() { return modelId; }
    public void setModelId(int modelId) { this.modelId = modelId; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }

    @Override
    public String toString() {
        return "Model{modelId=" + modelId + ", modelName=" + modelName + ", brandId=" + brandId + "}";
    }
}