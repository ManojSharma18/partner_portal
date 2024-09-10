const express = require("express");
const router = express.Router();
const { ManageSetting } = require("../models/manage_setting");

router.post("/", async (req, res) => {
  try {
    let {
      fp_unit_id,
      consumption_mode,
      fp_unit_avail_days_and_meals,
      fp_unit_sessions,
    } = req.body;

    const manageSetting = new ManageSetting({
      fp_unit_id,
      consumption_mode,
      fp_unit_avail_days_and_meals,
      fp_unit_sessions,
    });

    const savedManageSetting = await manageSetting.save();
    res.status(201).json(savedManageSetting);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
});

router.put("/:fp_unit_id", async (req, res) => {
  try {
    const { fp_unit_id } = req.params;
    const { consumption_mode, fp_unit_avail_days_and_meals, fp_unit_sessions } =
      req.body;

    // Find the document by fp_unit_id and update it
    const updatedManageSetting = await ManageSetting.findOneAndUpdate(
      { fp_unit_id: fp_unit_id },
      {
        consumption_mode,
        fp_unit_avail_days_and_meals,
        fp_unit_sessions,
      },
      { new: true } // This option returns the updated document
    );

    if (!updatedManageSetting) {
      return res.status(404).json({ message: "ManageSetting not found" });
    }

    res.status(200).json(updatedManageSetting);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
});

router.get("/:fp_unit_id", async (req, res) => {
  try {
    const { fp_unit_id } = req.params;

    // Find the document by fp_unit_id
    const manageSetting = await ManageSetting.findOne({
      fp_unit_id: fp_unit_id,
    });

    console.log(manageSetting);

    if (!manageSetting) {
      return res.status(404).json({ message: "ManageSetting not found" });
    }

    res.status(200).json(manageSetting);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
});

module.exports = router;
